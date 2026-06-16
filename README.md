# Ultimate VCF

A rebuilt **Vibe Coder Framework** for shipping production-quality features end-to-end, solo. It keeps VCF's backbone — the **6-tier system**, **Boil-the-Ocean** scope discipline, and the **Karpathy** code-quality rules — and rebuilds the loop around one idea the original missed.

## The one idea: the verifier gates acceptance

The original VCF let `build` hand unverified work to `audit`, so build was rationally sloppy and a slice would ping-pong 5–10× between "build" and "fix what audit found." Every robust self-improving system (SICA, Eidentic, Ivy Tendril) does the opposite: **a change is accepted only if it passes verification; a failing change is discarded, not patched downstream.**

Ultimate VCF moves that rule into the loop:

- **Build proves before it hands off.** A slice that fails its own tests, self-eval, or acceptance criteria does **not** advance.
- **Confirm confirms, it doesn't correct.** The independent reviewer validates a slice the builder already proved.
- **The loop is bounded.** Build self-verifies, then **max 2 confirm→fix rounds**; a 3rd finding means the approach is wrong → stop, question the plan, surface to the user.

## The 8-phase loop

| # | Command | Purpose |
|---|---|---|
| 0 | `/ultimate-vcf:uvcf-scope-lock` | Assess tier, **write** the phase-set to STATUS.md (no silent step-skipping) |
| 1 | `/ultimate-vcf:uvcf-ground` | Retrieve memory/git/docs/dangling threads; seed the decision-ledger |
| 2 | `/ultimate-vcf:uvcf-shape` | Brainstorm + grill + PRD collapsed → locked, testable acceptance criteria |
| 3 | `/ultimate-vcf:uvcf-plan-check` | Plan, then an independent checker confirms build can't improvise |
| 4 | `/ultimate-vcf:uvcf-build` | Red→Green then **PROVE** — verifier gates acceptance |
| 5 | `/ultimate-vcf:uvcf-confirm` | One independent reviewer; max 2 rounds then escalate; incident→test |
| 6 | `/ultimate-vcf:uvcf-verify` | Whole-feature goal-backward UAT; rewards outcome not steps |
| 7 | `/ultimate-vcf:uvcf-compound` | Ship + write back feature memory, ledger, **framework retro** |

`/ultimate-vcf:uvcf-overview` loads the full doctrine (tiers, modes, kept backbone).

## What it fixes (vs the original VCF)

- **Build↔audit moral hazard / the 10× ping-pong** → verifier-gates-acceptance (build owns correctness) + a 2-strike loop bound.
- **Overlapping audit gates** → collapsed into CONFIRM (per-slice, bounded) + VERIFY (whole-feature, goal-backward).
- **Doesn't compound/learn** → a learning spine: decision-ledger + per-slice self-eval + a framework-level retro + incident→regression-test promotion.
- **Ad-hoc step-skipping** → SCOPE-LOCK writes the chosen phase-set; skipping a locked phase is a logged deviation.

## Provenance

The discrete mechanics were mined (grounded in their files/papers) from **superpowers** (TDD, verification-before-completion, writing-plans), **GSD** (plan-checker, goal-backward verify), **BMAD** (dev-story, advanced-elicitation, check-implementation-readiness), the **ecc** context-economics skills (recursive-decision-ledger, agent-self-evaluation, strategic-compact, full-output-enforcement), **Karpathy**, and the systems architecture of self-improving agent frameworks — **SICA** (arXiv 2504.15228), **Eidentic**, **Ivy Tendril**, **Hive**, **Hermes**.

Full design rationale: `docs/superpowers/specs/2026-06-16-ultimate-vcf-design.md` (in the Joey repo where this was authored).

## Install

```
/plugin marketplace add /Users/tokiwilkinson/Projects/ultimate-vcf
/plugin install ultimate-vcf@ultimate-vcf
```

(Local marketplace; mirror of the `vcf-framework` plugin structure. Runs in parallel with `vcf-framework` — they don't collide because every command and skill is `uvcf-`-prefixed.)

## License

MIT.
