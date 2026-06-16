---
name: uvcf-confirm
description: Ultimate VCF Phase 5 — ONE independent reviewer (fresh context) confirms a built slice. Given the diff + acceptance criteria ONLY (never the builder's reasoning). Returns PASS or a bounded defect list. MAX 2 fix rounds, then the 3rd finding ESCALATES — stop, question the plan/architecture, surface to the user. Every confirmed defect becomes a regression test. Use after uvcf-build, or "uvcf confirm slice N of X".
---

# Ultimate VCF — Phase 5: CONFIRM

**Purpose:** the single per-slice review gate, and the loop bound. Because BUILD already proved the slice (Phase 4), CONFIRM's job is to *confirm* — catch what a self-author can't see — not to do the builder's work. And it is **bounded**, so a slice can't ping-pong forever.

This phase replaces the old VCF's overlapping slice-audit. There is ONE gate here, not several.

## Step 1 — One gate, reviewer picked by tier

This is a single gate whose reviewer scales with tier (not separate gates stacked):

| Tier | Reviewer |
|---|---|
| 1–2 | `Agent` → `feature-dev:code-reviewer` |
| 3 (default) | `/codex review` |
| 4 | `Agent` → `pr-review-toolkit:code-reviewer` per chunk |
| 5 | `/codex challenge` (adversarial) |

## Step 2 — Independence + audit the proof (not re-review the code)

Give the reviewer three things and nothing else: the **diff**, the slice's **acceptance criteria**, and the **`.proof` file** (`.vcf/<slug>/proof/slice-<N>.proof`). Never paste the builder's chat reasoning — that contaminates independence.

CONFIRM's job is to **audit the proof, then review what the proof can't show** — not to redo the build's work:

1. **Re-bind the proof.** Recompute `git diff HEAD | shasum -a 256` and compare it to the `DIFF_SHA256` in the `.proof`. If they differ, the code changed after the proof was written (stale or hand-edited) → **reject immediately**, the proof is void.
2. **Audit the evidence.** For each acceptance criterion, check that the named test actually appears in the `.proof`'s piped output as passing, and that the output is real (not a summary). A checkmark whose evidence is missing or fabricated → reject with specificity.
3. **Then review what the proof can't capture** — correctness beyond the tests, architectural fit vs the plan, edge cases, security/perf where relevant. This is the genuine reviewer value; a reviewer that hasn't seen your reasoning catches blind spots you can't.

This "audit the proof, don't re-review the code" framing (the council's sharpest operational insight) makes CONFIRM faster and gives both builder and reviewer nowhere to hand-wave.

## Step 3 — The 2-strike loop bound (the fix for the 10× ping-pong)

Count rounds:

- **Round 0** = BUILD's self-verification (already done in Phase 4).
- CONFIRM finds issues → builder fixes → **round 1**.
- CONFIRM again finds issues → builder fixes → **round 2**.
- CONFIRM finds issues a **third** time → **ESCALATE. Do not fix-and-loop again.**

Escalation means: stop, state that the slice has failed confirmation twice, conclude the approach is likely wrong, and surface to the user with a recommendation — re-open PLAN-CHECK, re-slice, or rethink the architecture. The repeated findings are a signal the plan or design is off, not that you need one more patch. (This matches the project's existing 2-strike error-loop kill-switch.)

## Step 4 — Incident → regression test

For **every confirmed defect**, write a failing regression test that reproduces it **first**, then fix it. Eidentic's rule: every incident becomes a test, not a repeat. This is how recurrence (and the "audit by invariant" class of bug) gets stamped out permanently.

## Step 5 — Output

Write `.vcf/<slug>/REVIEW-slice-N.md`: PASS or the defect list, the round count, and any deferred lower-severity items (so the next slice's BUILD reads them). Log decisions to LEDGER.md. **On PASS, advance `STATUS.md`** — mark slice N done and set `Current phase:` to the next slice's `build` (or `verify` if this was the last slice). In gate mode the next `/uvcf-build` reads STATUS.md to know which slice is next, so this write-back is mandatory. Then hand off: next slice's `/uvcf-build`, or `/uvcf-verify` if this was the last slice.
