---
name: uvcf-scope-lock
description: Ultimate VCF Phase 0. Assess the tier of the work, choose the exact set of phases that will run, and WRITE that step-set to .vcf/<slug>/STATUS.md before any other phase runs. Use when the user starts new non-trivial work, says "uvcf X", "let's build X with uvcf", or before invoking any other uvcf phase. The locked step-set is then followed; dropping or adding a phase later requires a logged deviation, not a silent skip.
---

# Ultimate VCF — Phase 0: SCOPE-LOCK

**Purpose:** kill ad-hoc step-skipping. The old VCF let `build` silently drop steps. Here, you decide *up front* — once you understand the scope — exactly which phases run, write them down, and then follow them. Skipping becomes a deliberate, logged choice instead of a quiet one.

This is the answer to "follow the actual steps, unless we're aware of the scope beforehand and tailor which steps we need."

## Step 1 — Assess the tier

Read the request. Place it on the 6-tier scale from scope signals (files touched, design uncertainty, security surface, repetition):

| Tier | Trigger | Phases that run |
|---|---|---|
| **1 — Tiny** | typo, 1-line fix, copy/colour tweak | `build → confirm(lite) → compound(quick)` |
| **2 — Small** | 1 feature, 1–3 files, design obvious, <1 day | `ground(light) → build → confirm → compound` |
| **3 — Medium** ⭐ default | multi-file, real design decisions, half–1 day | full spine: `scope-lock → ground → shape → plan-check → build → confirm → verify → compound` |
| **4 — Grindy** | 5+ similar items (per-provider, batch) | `ground → shape → plan-check`, then Ralph runs `build → confirm` per item, `verify → compound` at the end |
| **5 — Security-critical** | auth, RLS, OAuth, payment, multi-tenancy | full spine; CONFIRM uses `/codex challenge`; VERIFY adds `gsd-security-auditor` + `pr-review-toolkit:silent-failure-hunter` |
| **6 — Milestone** | multi-week, novel architecture | GSD outline scaffolding (`gsd-new-milestone`/`gsd-new-phase`) wrapping a Tier-3 spine per vertical slice |

If you're between tiers, pick the higher one. Boil-the-Ocean: don't under-scope to save effort.

## Step 2 — Lock the step-set

Pick the slug (kebab-case feature name). Write `.vcf/<slug>/STATUS.md`:

```
# <slug> — STATUS

Tier: <N> — <one-line why this tier>
Locked phases: <ordered list, e.g. ground → shape → plan-check → build → confirm → verify → compound>
Mode: <in-session | gate (clear between phases)>
Deviations: (none yet)

Current phase: scope-lock ✓ → <next>
```

Mode rule: Tier 1–2 → in-session; Tier 3+ → gate mode (`/clear` between phases so CONFIRM and PLAN-CHECK are genuinely independent of the build context).

## Step 3 — The deviation rule

The locked phases are now a contract. To skip or add one mid-flight, **append to `Deviations:`** with a one-line reason and update `Current phase:`. For example:

```
Deviations:
- 2026-06-16: skipped shape — scope came pre-specified in a stakeholder doc (PRD already exists).
```

Silent skipping is banned. If you catch yourself about to jump a phase without logging it, stop and log it first. (This is the structural fix for the pain "build skips steps as if on purpose.")

## Step 4 — Hand off

Tell the user the locked set and the next command, e.g.:

> Tier 3 locked. Phases: ground → shape → plan-check → build → confirm → verify → compound (gate mode). Next: `/uvcf-ground <slug>`.

Then stop. SCOPE-LOCK writes STATUS.md and advances state by one; it does not do the next phase's work.
