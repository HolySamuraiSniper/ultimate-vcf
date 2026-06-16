#!/usr/bin/env bash
# Ultimate VCF — handoff gate. Turns build's "I proved it" promise into a
# physical, un-fakeable artifact (the council's unanimous #1 hardening).
#
# It runs each proof command, captures the REAL combined output, binds the
# result to the exact code state via a git-diff hash, and writes a locked
# .proof file ONLY if every command exits 0. If any command fails, no .proof
# is written and the script exits non-zero — so the slice cannot advance.
#
# Usage:
#   bash handoff.sh --slug <feature> --slice <N> [--root <repo-root>] -- <cmd> [<cmd> ...]
# Example:
#   bash handoff.sh --slug route-planning --slice 3 -- \
#        "pnpm typecheck" "pnpm test:precommit" "pnpm lint"
#
# CONFIRM then reads .vcf/<slug>/proof/slice-<N>.proof and re-checks DIFF_SHA256
# against `git diff HEAD` — if they differ, the code changed after the proof was
# written (stale or forged) and confirm must reject.

set -uo pipefail

SLUG="" ; SLICE="" ; ROOT="."
while [ $# -gt 0 ]; do
  case "$1" in
    --slug)  SLUG="$2"; shift 2 ;;
    --slice) SLICE="$2"; shift 2 ;;
    --root)  ROOT="$2"; shift 2 ;;
    --) shift; break ;;
    *) echo "handoff: unknown arg '$1'" >&2; exit 2 ;;
  esac
done

[ -z "$SLUG" ]  && { echo "handoff: --slug is required" >&2; exit 2; }
[ -z "$SLICE" ] && { echo "handoff: --slice is required" >&2; exit 2; }
[ $# -eq 0 ]    && { echo "handoff: no proof commands given after --" >&2; exit 2; }

cd "$ROOT" || { echo "handoff: cannot cd to root '$ROOT'" >&2; exit 2; }

PROOF_DIR=".vcf/${SLUG}/proof"
mkdir -p "$PROOF_DIR"
PROOF_FILE="${PROOF_DIR}/slice-${SLICE}.proof"
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

# Bind the proof to the exact code state. Tracked + staged + unstaged diff.
DIFF_SHA="$(git diff HEAD 2>/dev/null | shasum -a 256 | awk '{print $1}')"
[ -z "$DIFF_SHA" ] && DIFF_SHA="no-git-or-no-changes"

FAILED=0
{
  echo "# Ultimate VCF proof — ${SLUG} slice ${SLICE}"
  echo "GENERATED: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "GIT_HEAD: $(git rev-parse --short HEAD 2>/dev/null || echo n/a)"
  echo "DIFF_SHA256: ${DIFF_SHA}"
  echo
} > "$TMP"

for cmd in "$@"; do
  echo "=== \$ ${cmd} ===" >> "$TMP"
  # Run the command, tee its real output into the proof.
  OUT="$(bash -c "$cmd" 2>&1)"; CODE=$?
  echo "$OUT" >> "$TMP"
  echo "--- exit ${CODE} ---" >> "$TMP"
  echo >> "$TMP"
  [ "$CODE" -ne 0 ] && FAILED=1
done

if [ "$FAILED" -ne 0 ]; then
  echo >> "$TMP"
  echo "RESULT: FAIL — slice does NOT advance. Fix in build; do not hand off." >> "$TMP"
  cat "$TMP" >&2
  echo "handoff: ✗ proof FAILED — no .proof written, slice cannot advance." >&2
  exit 1
fi

echo "RESULT: PASS" >> "$TMP"
mv "$TMP" "$PROOF_FILE"
trap - EXIT
chmod 0444 "$PROOF_FILE" 2>/dev/null || true   # lock (read-only) so it isn't casually edited
echo "handoff: ✓ proof written to ${PROOF_FILE} (DIFF_SHA256=${DIFF_SHA})"
echo "Next: /clear → /uvcf-confirm ${SLUG} slice ${SLICE} (reviewer reads this .proof + the diff)."
