---
name: uvcf-ground
description: Ultimate VCF Phase 1. Ground the work and RETRIEVE prior context before any new thinking — claude-mem search, git log/blame on files you'll touch, CLAUDE.md/CONTEXT.md/glossary, prior REVIEW/CLOSEOUT dangling threads — then seed the decision-ledger. Use after scope-lock, or when the user says "uvcf ground X" / "context for X". Writes .vcf/<slug>/LEDGER.md. Most "AI slop" comes from skipping this; the first five minutes save hours.
---

# Ultimate VCF — Phase 1: GROUND

**Purpose:** the "retrieve" half of context-in → context-out. Before any new thinking, pull in what's already known so you don't re-derive or contradict prior decisions. This is also where the decision-ledger is born.

## Step 1 — Retrieve (checklist, do all that apply)

- **Memory:** `claude-mem:mem-search` for prior decisions, gotchas, attempted approaches on this domain. ("Did we already solve this?")
- **Git:** `git log -20` on the area; `git blame` on the specific files you expect to touch. Recent commits often invalidate what you think you know.
- **Project docs:** read `CLAUDE.md` / `AGENTS.md`, `CONTEXT.md`, `docs/glossary.md` for canonical vocabulary and constraints.
- **Dangling threads:** scan prior `.vcf/*/CLOSEOUT.md` and `.vcf/*/REVIEW-slice-*.md` for "Gotchas" / "Dangling threads" in the same domain (cross-feature leak prevention).

## Step 2 — The three-things rule

Write down **at least three things that change your approach** plus any unverified assumptions. If you can't list three, you didn't look hard enough — go back to Step 1.

## Step 3 — Seed the decision-ledger

Create `.vcf/<slug>/LEDGER.md` (append-only) from the template at `uvcf-overview/templates/LEDGER.md`. Add the initial framing decision (what we're building and the one approach chosen so far).

**Temporal-KG rule:** the ledger never deletes. When a later decision contradicts an earlier one, mark the earlier `status: superseded-by-#N` rather than removing it — the trail of *why we changed our mind* is the valuable part.

## Step 4 — Surface project gotchas (Joey)

When grounding on the Joey codebase, surface these in the ledger if the work touches them:

- **FK guards** on cross-tenant inputs (`src/lib/ai/tools/_fk-guards.ts`; test `fk-guard-import.test.ts`).
- **Schema budget** ceiling 4096 tokens (`schema-budget.test.ts`) — never raise it.
- **Post-auth UI** → read `.stitch/DESIGN.md` + `.stitch/COMPONENTS.md` first.
- **Multi-tenant** → ADR-0002; RLS is the only barrier between tenants.
- **Glossary / memory vocabulary** → `docs/glossary.md`; Hukommelse / Samtaleresumé / Hændelse.

## Hand off

Summarise the 3 things + assumptions, confirm LEDGER.md seeded, point to the next phase (`/uvcf-shape <slug>` for Tier 3+, or `/uvcf-build` if the locked set skips shape/plan-check). Stop.
