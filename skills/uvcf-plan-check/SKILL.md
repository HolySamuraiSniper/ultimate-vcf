---
name: uvcf-plan-check
description: Ultimate VCF Phase 3. Produce the technical plan AND gate it — an independent plan-checker confirms the plan is complete enough that BUILD cannot improvise. This is the upstream half of the build↔audit moral-hazard fix. Bounded revision with stall detection. Use after shape, or "uvcf plan X" / "plan-check X". Writes .vcf/<slug>/PLAN.md.
---

# Ultimate VCF — Phase 3: PLAN-CHECK

**Purpose:** the upstream half of the moral-hazard fix. If the plan is incomplete, the builder *has* to improvise, and improvisation is where defects come from. PLAN-CHECK makes the plan so complete that build is mechanical — there's nothing to wing. (BMAD dev-story + GSD plan-checker.)

## Step 1 — Plan

Use **Plan Mode** (`EnterPlanMode` → `ExitPlanMode`) for anything touching >3 files or crossing module boundaries (`superpowers:writing-plans` for smaller plans). Cover:

- File-tree changes (exact paths created/modified).
- Module boundaries + interfaces (types, signatures).
- Data flow.
- A threat-model paragraph (what could go wrong; for Tier 5, expand it).
- **Vertical-slice breakdown** — each slice is end-to-end (DB column → DAL → tool/route → UI affordance → test), never horizontal (all migrations, then all routes, then all UI). If the breakdown looks horizontal, restructure before continuing.
- Per-slice verification strategy: what proof commands + acceptance criteria gate each slice.

Write to `.vcf/<slug>/PLAN.md`.

## Step 2 — The completeness standard (dev-story)

Each slice in the plan must carry **its own acceptance criteria + the architecture notes needed to build it**. The test: *could a fresh builder execute this slice without guessing?* If a slice would force a design decision at build time, that decision belongs here, now.

**Proof-plan (per slice) — declared before any code.** Each slice also states *how it will prove itself*: the exact test names/assertions that will cover each acceptance criterion, and the proof commands `handoff.sh` will run (typecheck/test/lint/eval). This is a commitment device — the builder builds *toward* the proof instead of retrofitting a passing self-score to whatever it happened to write (the LLM-council's anti-rubber-stamp fix). The readiness gate (Step 3) checks the proof-plan exists and every criterion maps to a named test; a slice whose criteria can't be expressed as a test is a signal it's under-specified or belongs in exploratory mode, not this loop.

## Step 3 — The readiness gate (plan-checker)

Hand the plan to an **independent reviewer in fresh context** — `Plan` agent or `feature-dev:code-architect`. Give it PRD.md + PLAN.md. It verifies:

1. Every PRD acceptance criterion maps to at least one slice.
2. No slice requires improvisation (the dev-story standard).
3. Slices are vertical, not horizontal.
4. Interfaces between slices are defined.
5. **Every slice has a proof-plan** — each acceptance criterion maps to a named test/assertion, and the `handoff.sh` proof commands are listed. (No proof-plan = not READY.)

It returns **READY** or a specific **gap list**.

## Step 4 — Bounded revision (stall detection)

If gaps come back: revise the plan and re-check. **Max 3 revision rounds.** If the gap count isn't shrinking between rounds (stall), stop and surface to the user — the work may be under-specified at the SHAPE level and needs to go back, not loop here.

## Step 5 — Output

Once it passes, stamp `PLAN.md` with `Readiness: READY`. Log key architecture decisions to LEDGER.md. Update STATUS.md. Hand off to `/uvcf-build <slug>` (slice 1).
