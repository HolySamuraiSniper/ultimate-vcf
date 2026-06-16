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

## Autoresearch mode (optional)

Use this only when a slice's success criterion is a **measurable metric to optimize** (eval accuracy, p95 latency, test-pass-rate, tool-selection score) rather than a fixed behavior to implement. Instead of a one-shot BUILD, run an autonomous optimization loop. The mechanics below are lifted from Karpathy's `autoresearch` `program.md` (reference clone at `~/Projects/autoresearch` — read it):

- **Frozen, external evaluator = ground truth.** The metric and its harness are read-only; the loop edits the *implementation*, never the evaluator. This is the anti-gaming rule and the deepest tie to verifier-gates-acceptance — the metric is never self-graded. (autoresearch: `evaluate_bpb` lives in the un-editable `prepare.py`.)
- **Fixed budget per experiment** (time or tokens) → every experiment is directly comparable regardless of what changed.
- **git *is* the accept/discard.** Commit each experiment on a `autoresearch/<tag>`-style branch; if the metric improves, keep the commit and advance; if equal-or-worse, `git reset` back. First run = establish the baseline.
- **Append-only ledger** (`results.tsv`-style: `commit | metric | cost | status(keep/discard/crash) | description`, untracked) so learnings accumulate and feed the decision-ledger / framework-retro.
- **Crash handling = bounded.** Trivial fix → retry; otherwise log `crash` and move on after a few attempts (the same 2-strike escalation discipline). Apply the simplicity criterion: a tiny gain that adds ugly complexity isn't worth it; a gain from *deleting* code always is.

On Joey this is the existing `/auto-research <target>` framework (`.auto-research/`, target types: criteria-check / test-pass-rate / skill-trigger); pair with `/ralph-loop` for unattended overnight runs. It slots in as the BUILD phase for metric-driven slices (PLAN-CHECK still locks the metric + budget + frozen evaluator; CONFIRM/VERIFY still gate the winning experiment). Optional — most slices are behavior-driven and use normal BUILD.

## Kept backbone (always-on, not steps)

- **Boil-the-Ocean** scope discipline + the 5 banned anti-patterns — invoke `boil-the-ocean` to reset mid-loop.
- **Karpathy code-quality rules** — think-before-coding, simplicity-first, surgical changes, goal-driven — `andrej-karpathy-skills:karpathy-guidelines`.

## When to skip phases

Skips are decided at **SCOPE-LOCK** and written down — never silent mid-build. To drop or add a locked phase later, append to `Deviations:` in STATUS.md with a one-line why. Phases that almost never skip: GROUND (one minute beats zero), CONFIRM (independent eyes), VERIFY (integration drift), COMPOUND's write-back (compounding only happens if you feed it).

## The shape, once more

GROUND **retrieves** prior context; COMPOUND **stores** what was learned — including a framework-level retro that improves this loop itself. Skip the write-back and the loop is one-shot. Honor it and the system compounds.
