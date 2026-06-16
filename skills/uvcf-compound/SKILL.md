---
name: uvcf-compound
description: Ultimate VCF Phase 7 — ship and compound. Atomic commits with WHY, docs/changelog, ship via /ship or superpowers:finishing-a-development-branch. Then write back THREE ways — feature memory (claude-mem + vault), ledger promotion, and a FRAMEWORK retro asking "which phase failed and what should change in the loop itself?". Commit incident regression tests. Use after uvcf-verify, or "uvcf closeout X" / "ship X".
---

# Ultimate VCF — Phase 7: COMPOUND

**Purpose:** the "context-out" half. The loop only compounds if you feed it. COMPOUND ships the work and writes back at two levels — the feature, and **the framework itself**. Skip this and every loop starts from zero.

## Step 1 — Ship

- Update README/docs/changelog for what changed.
- Final atomic commits with messages that say **WHY**, not what.
- Ship via `superpowers:finishing-a-development-branch`, `/ship`, or `/land-and-deploy`.
- Confirm the **incident regression tests** from CONFIRM are committed (so defects can't recur).

## Step 2 — Feature write-back

- `claude-mem` — record surprises, decisions worth remembering, gotchas for the next loop, new invariants.
- **Obsidian vault** — compile a wiki article via `obsidian-cli` (Joey mandatory rule): what shipped, why, and the gotchas. Update the domain index + root index + log.

## Step 3 — Ledger promotion

In `.vcf/<slug>/LEDGER.md`, promote the decisions that held; mark any that were superseded during the loop. The ledger is the durable "what we decided and why we changed our minds" trail (temporal-KG semantics).

## Step 4 — Framework retro (the meta-loop)

This is what makes the *framework* improve, not just the feature memory. Using `templates/FRAMEWORK-RETRO.md`, answer honestly:

- **Which phase failed or felt heavy this loop?** (Did a slice ping-pong? Did PLAN-CHECK miss a gap that surfaced in BUILD? Did CONFIRM escalate?)
- **What single rule/step change would have prevented it?**
- **One concrete edit to the loop for next time.**

Write the answer to a `framework-lessons` memory and, when the change is real, append it to the Ultimate VCF design doc's changelog (`docs/superpowers/specs/2026-06-16-ultimate-vcf-design.md` in the Joey repo, if present) or to the plugin's own CHANGELOG. This is SICA's Feedback-Agent idea at human-in-the-loop cadence: the harness is a learning target, not a fixed artifact.

## Step 5 — Output

Write `.vcf/<slug>/CLOSEOUT.md` summarising what shipped, dangling threads, and the framework lesson. Update STATUS.md to done. The loop is complete — and the next one starts smarter.
