#!/usr/bin/env bash
# Ultimate VCF — pre-commit gate. The "physically un-bypassable" notch above
# handoff.sh: handoff.sh is a script the builder is TOLD to run; this hook
# makes the COMMIT itself refuse unless a fresh, diff-matching .proof exists
# for any uvcf build slice that is awaiting confirmation.
#
# SCOPED + SAFE BY DESIGN:
#   - Only fires when a .vcf/<slug>/STATUS.md is in an active build phase
#     ("Current phase:" mentions both 'build' and 'awaiting confirm').
#   - On any other commit (docs, non-uvcf repos, no active build) it passes
#     through silently — it will NOT block normal work.
#   - Escape hatch: `git commit --no-verify` always bypasses (standard git).
#
# Pass = exit 0. Block = exit 1 with an explanation.

set -uo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0
cd "$ROOT" || exit 0

# Current code state, SAME basis handoff.sh stamps: code changes vs HEAD,
# excluding .vcf/ bookkeeping (proof + STATUS live there and must not perturb it).
CUR_SHA="$(git diff HEAD -- . ':(exclude).vcf' 2>/dev/null | shasum -a 256 | awk '{print $1}')"
[ -z "$CUR_SHA" ] && CUR_SHA="no-git-or-no-changes"

blocked=0
for status in .vcf/*/STATUS.md; do
  [ -f "$status" ] || continue
  # Is this feature mid-build, awaiting confirmation?
  phase_line="$(grep -i 'Current phase:' "$status" | tail -1)"
  echo "$phase_line" | grep -qi 'build'          || continue
  echo "$phase_line" | grep -qi 'awaiting confirm' || continue

  slug="$(basename "$(dirname "$status")")"
  proof_dir=".vcf/${slug}/proof"

  # Find a .proof whose DIFF_SHA256 matches the current diff.
  match=0
  if [ -d "$proof_dir" ]; then
    for p in "$proof_dir"/*.proof; do
      [ -f "$p" ] || continue
      psha="$(grep -m1 '^DIFF_SHA256:' "$p" | awk '{print $2}')"
      [ "$psha" = "$CUR_SHA" ] && { match=1; break; }
    done
  fi

  if [ "$match" -ne 1 ]; then
    echo "✗ uvcf: '$slug' is mid-build awaiting confirm, but no .proof matches the current code." >&2
    echo "  Expected a fresh ${proof_dir}/slice-<N>.proof with DIFF_SHA256=${CUR_SHA}." >&2
    echo "  → Re-run build's handoff.sh to re-prove the slice, then commit." >&2
    echo "    (Bypass intentionally with: git commit --no-verify)" >&2
    blocked=1
  fi
done

exit $blocked
