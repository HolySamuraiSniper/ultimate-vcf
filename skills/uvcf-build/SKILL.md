---
name: uvcf-build
description: Ultimate VCF Phase 4 — build one vertical slice with RED→GREEN then PROVE. The verifier gates acceptance — a slice that fails its own tests, self-eval, or acceptance criteria does NOT advance to confirm. Build owns correctness so the reviewer confirms rather than corrects. Use after plan-check, or "uvcf build slice N of X". Runs once per slice; in gate mode, expect /clear + /uvcf-confirm between slices.
---

# Ultimate VCF — Phase 4: BUILD + PROVE

**This phase carries the core fix for the build↔audit moral hazard.** The old VCF let build hand unverified work to audit, so build was rationally sloppy and slices ping-ponged. Here, **the verifier gates acceptance**: a slice only advances if it has already proven itself. Build owns correctness; CONFIRM then merely confirms.

## Step 1 — Read first

- `.vcf/<slug>/PLAN.md` + `STATUS.md` to find the current slice and its acceptance criteria.
- **All prior `.vcf/<slug>/REVIEW-slice-*.md`** for deferred P1/P2/P3 issues and integration warnings — factor them in now (leak prevention).

## Step 2 — Red → Green

Use `superpowers:test-driven-development` (or `/tdd`):

1. Write failing tests directly from this slice's acceptance criteria.
2. Run them; **watch them fail** (if you didn't see it fail, you don't know it tests the right thing).
3. Write the *minimal* code to green. Karpathy: simplest thing that works, surgical changes only.

## Step 3 — PROVE (verifier-gates-acceptance — non-negotiable)

Before this slice may advance to CONFIRM, ALL of the following must hold. This is the gate.

1. **Run the proof commands and paste the actual output** — tests, typecheck, lint, and any relevant evals. Evidence before claims (`superpowers:verification-before-completion`). "Should pass" is not proof; pasted green output is.
2. **Self-score 5 axes with evidence** (`agent-self-evaluation`), at this slice boundary (the Hermes cadence — pause and self-evaluate, don't wait for the end). Use `templates/SELF-EVAL.md`. Any axis < 5 must cite concrete evidence and get a fix:
   - accuracy · completeness · clarity · surgical-ness · no-placeholders
3. **No placeholders** (`full-output-enforcement`): no `// ...`, no "similar to above", no half-finished impls that pass tests without doing the work. Every changed line traces to this slice.
4. **Acceptance-criteria check**: each criterion for this slice is demonstrably met (point at the test or behaviour that proves it).

**If any of the four fails, the slice does NOT advance.** Fix it now, in BUILD. Build does not hand broken or unproven work to CONFIRM. (This is SICA's rule: a change is accepted only if it passes verification; a failing change is fixed or discarded, never passed downstream.)

## Step 4 — Record

Append `.vcf/<slug>/BUILD-NOTES.md` with: the slice, the pasted proof output, the self-eval scores. Log any non-trivial decisions to `LEDGER.md` (supersede contradicted ones). **Update `STATUS.md`** `Current phase:` to `build · slice N proven, awaiting confirm` — in gate mode the next `/uvcf-confirm` reads STATUS.md to learn which slice it is confirming, so this write-back is mandatory.

## Step 5 — Hand off

State the slice is PROVEN and ready for independent confirmation. In gate mode, tell the user to `/clear` then `/uvcf-confirm <slug> slice <N>`. One slice per invocation.

---

**Always-on:** Boil-the-Ocean (do the whole in-scope thing, no deferral when the real fix is in reach) + Karpathy (think before coding, simplicity, surgical changes, goal-driven). If you feel the pull to leave a thread "for the reviewer to catch," that is the exact moral hazard this phase exists to kill — tie it off now.
