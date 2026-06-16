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

## Step 2 — Independence

Give the reviewer the **diff + the slice's acceptance criteria, and nothing else.** Never paste the builder's reasoning or self-eval — that contaminates independence. A reviewer that hasn't seen your reasoning catches the blind spots you can't.

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
