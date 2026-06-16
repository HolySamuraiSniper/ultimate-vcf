---
name: uvcf-shape
description: Ultimate VCF Phase 2. One convergent step that collapses brainstorm + grill + PRD — problem in the user's words, 2-3 alternative shapes with the picked one, hard constraints, and LOCKED testable acceptance criteria. Includes an advanced-elicitation depth-forcing pass. Use after ground, or "uvcf shape X" / "lock acceptance criteria for X". Writes .vcf/<slug>/PRD.md.
---

# Ultimate VCF — Phase 2: SHAPE

**Purpose:** the old VCF split brainstorm, grill, and prd into three steps that blurred together. SHAPE collapses them into one convergent pass whose single deliverable is **locked, testable acceptance criteria** — the criteria that become red tests in BUILD. Upstream quality here is the cheapest place to prevent downstream rework.

## Step 1 — Converge on the shape

- For novel work, run `superpowers:brainstorming` to explore intent → 2-3 alternative shapes → the picked one with tradeoffs. (Well-understood incremental work can skip straight to criteria.)
- **For user-facing work, run `user-first-thinking` first** — ground the problem and the acceptance criteria in the actual end-user's need (ICP empathy, real workflow), not in what's convenient to implement. Skip for internal/infra work that has no end-user surface.
- **Grill the design against the documented domain model with `grill-with-docs`** (the canonical UVCF grill) — it stress-tests the plan against `CONTEXT.md` / ADRs / glossary and updates those docs inline as decisions crystallise, so terminology and prior decisions stay coherent.
- Per the project rule: **grilling questions go through `AskUserQuestion`, never prose.**

## Step 2 — Lock acceptance criteria

Write concrete, testable acceptance criteria — each must be checkable by a test or an observable user outcome. Plus:

- Explicit **in / out of scope** (out should be longer than in — Boil-the-Ocean means doing the whole *in-scope* thing, not expanding scope).
- **Non-goals** and success metrics.

These criteria are the contract VERIFY checks at the end and the source of BUILD's red tests.

## Step 3 — Advanced-elicitation depth-forcing pass

After the first draft, apply ONE depth-forcing method to surface hidden assumptions before moving on (BMAD advanced-elicitation):

- **Socratic** — "what must be true for this to work?"
- **Red-Team** — "how would this fail / be abused?"
- **First-Principles** — "strip it to the irreducible requirement."

Fold what it surfaces back into the criteria. This pass is cheap now and expensive to skip (it's where "we didn't think of that" gets caught before build).

## Step 4 — Output

Write `.vcf/<slug>/PRD.md` (user stories, acceptance criteria, in/out scope, non-goals, metrics). Log scope decisions to `.vcf/<slug>/LEDGER.md`. Update STATUS.md `Current phase:`. Hand off to `/ultimate-vcf:uvcf-plan-check <slug>`.
