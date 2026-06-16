---
name: uvcf-build
description: Ultimate VCF Phase 4 — build one vertical slice with RED→GREEN then PROVE. The verifier gates acceptance — a slice that fails its own tests, self-eval, or acceptance criteria does NOT advance to confirm. Build owns correctness so the reviewer confirms rather than corrects. Use after plan-check, or "uvcf build slice N of X". Runs once per slice; in gate mode, expect /clear + /ultimate-vcf:uvcf-confirm between slices.
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

## Step 3 — PROVE (verifier-gates-acceptance — the gate)

Build does not hand work to CONFIRM on a promise — it hands a **proof artifact bound to the exact code**. Run the enforcement script (`handoff.sh`, in this skill's directory). It executes each proof command, captures the REAL combined stdout/stderr, stamps a `DIFF_SHA256` of `git diff HEAD`, and writes `.vcf/<slug>/proof/slice-<N>.proof` **only if every command exits 0** — otherwise it exits non-zero and writes nothing, so a failing slice physically cannot advance:

```bash
bash "<dir of this SKILL.md>/handoff.sh" --slug <slug> --slice <N> -- \
  "<typecheck cmd>" "<test cmd>" "<lint cmd>" "<eval cmd if any>"
```

The commands come from the slice's **proof-plan**, locked in PLAN-CHECK (so you build *toward* the proof, not retrofit a score). Joey example: `"pnpm typecheck" "pnpm test:precommit" "pnpm lint"` (+ `"pnpm test:eval"` / `"pnpm test schema-budget"` when relevant).

Then complete the proof — these are checkable, not vibes:

1. **Criterion → test map.** For each acceptance criterion of this slice, name the passing test/assertion that proves it (`Criterion 2 ✓ — auth.test.ts::rejects_expired_token`). A criterion with no named test is **not met**.
2. **Self-score the 5 axes with cited evidence** (`agent-self-evaluation`) into `templates/SELF-EVAL.md` — accuracy · completeness · clarity · surgical-ness · no-placeholders. Make checks binary where possible (`grep -rn 'TODO\|FIXME\|XXX' <changed files>` → 0). Any axis < 5 cites file/line evidence and gets fixed now.
3. **No placeholders** (`full-output-enforcement`): no `// ...`, no "similar to above", no impl that passes tests without doing the work.

**If `handoff.sh` exits non-zero, OR any criterion lacks a named passing test, the slice does NOT advance.** Fix it now, in BUILD. Build never hands broken or unproven work to CONFIRM. (SICA: a change is accepted only if it passes verification; a failing change is fixed or discarded, never passed downstream.)

> **Why a script, not just a prompt:** prompt-level discipline is the floor; `handoff.sh` is the teeth. It was the LLM-council's unanimous #1 hardening — "turn prompt-level promises into physical CI-like boundaries the AI cannot bypass." The self-score alone is rubber-stamp theater; binding it to real piped output + a diff hash that CONFIRM re-checks is what makes it real.

> **Make it un-bypassable (optional, recommended once you trust the loop):** `handoff.sh` is still a script the builder is *told* to run. To make the *commit itself* refuse unless a fresh, diff-matching `.proof` exists, install the pre-commit gate once per project: `bash "<this skill dir>/install-uvcf-hook.sh" /path/to/repo`. It fires ONLY when a `.vcf/<slug>` slice is awaiting confirm (silent otherwise), and `git commit --no-verify` is the deliberate escape hatch. Caveat: don't install it into a repo with many parallel agent sessions committing on one shared tree without coordinating — it gates every committer.

## Step 4 — Record

Append `.vcf/<slug>/BUILD-NOTES.md` with: the slice, the `.proof` path (`.vcf/<slug>/proof/slice-<N>.proof`), the criterion→test map, and the self-eval scores. Log any non-trivial decisions to `LEDGER.md` (supersede contradicted ones). **Update `STATUS.md`** `Current phase:` to `build · slice N proven, awaiting confirm` — in gate mode the next `/ultimate-vcf:uvcf-confirm` reads STATUS.md to learn which slice it is confirming, so this write-back is mandatory.

## Step 5 — Hand off

State the slice is PROVEN and ready for independent confirmation. In gate mode, tell the user to `/clear` then `/ultimate-vcf:uvcf-confirm <slug> slice <N>`. One slice per invocation.

---

**Always-on:** Boil-the-Ocean (do the whole in-scope thing, no deferral when the real fix is in reach) + Karpathy (think before coding, simplicity, surgical changes, goal-driven). If you feel the pull to leave a thread "for the reviewer to catch," that is the exact moral hazard this phase exists to kill — tie it off now.
