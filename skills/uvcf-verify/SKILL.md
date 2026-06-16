---
name: uvcf-verify
description: Ultimate VCF Phase 6 — the single whole-feature gate. Goal-backward UAT against PRD acceptance criteria, run once before compound. Rewards the user OUTCOME, not step-completion. Catches integration drift no per-slice confirm can see (partial migrations, half-removed scaffolding, dangling TODOs, telemetry that fires but is never read). Use after the last slice's confirm, or "uvcf verify X" / "final audit X".
---

# Ultimate VCF — Phase 6: VERIFY

**Purpose:** the one whole-feature gate. CONFIRM checks slices locally; VERIFY checks the assembled feature against what the user actually wanted, and sweeps for the integration drift that only appears once the pieces are together. It replaces the old VCF's sprawling final-audit with a single, outcome-focused pass.

## Step 1 — Goal-backward UAT (GSD verify-work)

For each PRD acceptance criterion, ask plainly: **"Here's what the user should be able to observe — does it actually happen?"** Walk the real flow, not the implementation. Record observed vs expected per criterion.

## Step 2 — Reward outcome, not steps (Hive)

A slice can pass all its tests and still miss the user outcome. If a criterion's *outcome* isn't met, it FAILS here even if every step was "done." Record the gap as a **learning event** for the ledger (this is signal about where SHAPE/PLAN under-specified).

## Step 3 — Integration-drift sweep

Catch what per-slice confirm structurally cannot see:

- Partial migrations / half-removed scaffolding / dead feature flags.
- Dangling TODOs introduced during build.
- Telemetry that fires but is never read.
- **Cross-cutting invariants enumerated across ALL call sites, not just the diff** — opt-out honoured, FK scope enforced, atomic claim held. (Joey rule: audit by invariant, not by diff — enumerate every site, because a bypass can hide in an unchanged path.)

## Step 4 — Tier extras

- **Tier 5:** also run `Agent` → `gsd-security-auditor` and `Agent` → `pr-review-toolkit:silent-failure-hunter`.
- **Post-auth UI:** also run `Skill: audit` (the AI-slop / design-system gate).

## Step 5 — Output and routing

Write `.vcf/<slug>/VERIFY.md` with the criterion-by-criterion result and any drift found. Failures route back to `/uvcf-plan-check` (re-plan the gap) or a targeted `/uvcf-build` slice — **not** into an unbounded fix loop here. On PASS, hand off to `/uvcf-compound <slug>`.
