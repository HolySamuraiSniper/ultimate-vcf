---
name: uvcf-overview
description: Loads the Ultimate VCF doctrine — the 8-phase loop (scope-lock → ground → shape → plan-check → build → confirm → verify → compound), the build↔audit moral-hazard fix, the 6-tier scaling, and the kept backbone (Boil-the-Ocean, Karpathy). Use when the user asks "what is ultimate vcf", "uvcf overview", "show me the uvcf loop", picks a tier, or starts a feature and needs to choose one. Reference only — writes no files and advances no state.
---

# Ultimate VCF — Overview

A rebuild of the Vibe Coder Framework. Same backbone, sharper mechanics. The shape is still **context-in → context-out**, but the loop is reorganised around one idea the old VCF missed.

## The one idea: the verifier gates acceptance

The old VCF let `build` hand unverified work to `audit`, and let `audit` absorb the cost. So build was rationally sloppy and slices ping-ponged 5–10× between build and fix. Every robust self-improving system (SICA, Eidentic, Ivy Tendril) does the opposite: **a change is accepted only if it passes verification; a failing change is discarded, not patched downstream.**

Ultimate VCF moves that rule into the loop:

- **Build proves before it hands off.** A slice that fails its own tests, self-eval, or acceptance criteria does **not** advance. Build owns correctness.
- **Confirm confirms, it doesn't correct.** The independent reviewer validates a slice the builder already proved — not a first-draft.
- **The loop is bounded.** Build self-verifies, then **max 2 confirm→fix rounds**; a 3rd finding means the approach is wrong → STOP, question the plan/architecture, surface to the user. No infinite loop.

## The 8 phases

| # | Phase | Command | Purpose | Fixes |
|---|---|---|---|---|
| 0 | **SCOPE-LOCK** | `/ultimate-vcf:uvcf-scope-lock` | Assess tier, choose the exact phase-set, write it to STATUS.md | ad-hoc step-skipping |
| 1 | **GROUND** | `/ultimate-vcf:uvcf-ground` | Retrieve prior context (memory, git, docs, dangling threads); seed the ledger | slop-from-no-context |
| 2 | **SHAPE** | `/ultimate-vcf:uvcf-shape` | Brainstorm + grill + PRD collapsed → locked testable acceptance criteria | early-step overlap |
| 3 | **PLAN-CHECK** | `/ultimate-vcf:uvcf-plan-check` | Plan, then an independent checker confirms build can't improvise | moral hazard (upstream) |
| 4 | **BUILD** | `/ultimate-vcf:uvcf-build` | Red→Green then **PROVE**; verifier gates acceptance | moral hazard (downstream) |
| 5 | **CONFIRM** | `/ultimate-vcf:uvcf-confirm` | One independent reviewer, diff-only; max 2 rounds then escalate | the loop + gate overlap |
| 6 | **VERIFY** | `/ultimate-vcf:uvcf-verify` | Whole-feature goal-backward UAT; rewards outcome not steps | integration drift |
| 7 | **COMPOUND** | `/ultimate-vcf:uvcf-compound` | Ship + write back feature memory, ledger, **framework retro** | doesn't compound/learn |

Kaizen (continuous refactor) and sprint (parallelism) are **practices inside phases**, not steps.

## 6-tier scaling

The tier decides which phases run. SCOPE-LOCK writes the chosen set to `.vcf/<slug>/STATUS.md`.

| Tier | Trigger | Phases run |
|---|---|---|
| **1 — Tiny** | typo, 1-line fix, copy tweak | `build → confirm(lite) → compound(quick)` |
| **2 — Small** | 1 feature, 1–3 files, obvious design | `ground(light) → build → confirm → compound` |
| **3 — Medium** ⭐ default | multi-file, real design decisions | full 0–7 spine |
| **4 — Grindy** | 5+ similar items | `0–3`, then Ralph runs `build → confirm` per item, `verify + compound` at the end (checkpoint between waves) |
| **5 — Security-critical** | auth, RLS, OAuth, payment, multi-tenancy | full spine; CONFIRM = `/codex challenge`; VERIFY adds `gsd-security-auditor` + `pr-review-toolkit:silent-failure-hunter` |
| **6 — Milestone** | multi-week, novel architecture | GSD outline scaffolding wraps a Tier-3 spine per vertical slice |

## Two modes

- **In-session** (Tier 1–2): walk the chosen phases inline in one chat.
- **Gate mode** (Tier 3+, default): one command per phase, `/clear` between phases so each runs in fresh context — this is what makes CONFIRM and PLAN-CHECK genuinely independent.

## Kept backbone (always-on, not steps)

- **Boil-the-Ocean** scope discipline + the 5 banned anti-patterns — invoke `boil-the-ocean` to reset mid-loop.
- **Karpathy code-quality rules** — think-before-coding, simplicity-first, surgical changes, goal-driven — `andrej-karpathy-skills:karpathy-guidelines`.

## When to skip phases

Skips are decided at **SCOPE-LOCK** and written down — never silent mid-build. To drop or add a locked phase later, append to `Deviations:` in STATUS.md with a one-line why. Phases that almost never skip: GROUND (one minute beats zero), CONFIRM (independent eyes), VERIFY (integration drift), COMPOUND's write-back (compounding only happens if you feed it).

## The shape, once more

GROUND **retrieves** prior context; COMPOUND **stores** what was learned — including a framework-level retro that improves this loop itself. Skip the write-back and the loop is one-shot. Honor it and the system compounds.
