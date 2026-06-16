# <slug> slice <N> — Proof + Self-Eval (BUILD Phase 4)

> Written by the builder at the slice boundary, BEFORE handoff. This is a **proof artifact**, not a vibe check — every claim cites checkable evidence. The slice does not advance until `handoff.sh` exits 0 AND every criterion below maps to a named passing test. CONFIRM audits THIS file + the `.proof` (it re-checks the diff hash). (agent-self-evaluation + verifier-gates-acceptance + the LLM-council anti-rubber-stamp hardening.)

**Proof artifact:** `.vcf/<slug>/proof/slice-<N>.proof` · `DIFF_SHA256: <from the .proof>`

## Criterion → test map (every criterion needs a named passing test)
| Acceptance criterion | Proving test/assertion | In .proof output? |
|---|---|---|
| C1: … | `file.test.ts::name` | ✓ |
| C2: … | `file.test.ts::name` | ✓ |

## Binary checks
- [ ] `handoff.sh` exited 0 (all proof commands green) — see `.proof`
- [ ] `grep -rn 'TODO\|FIXME\|XXX' <changed files>` → 0
- [ ] every changed line traces to this slice (no drive-by edits)
- [ ] no impl that passes tests without doing the real work

## 5-axis self-score (cite file/line evidence for anything < 5)
| Axis | 1–5 | Evidence |
|---|---|---|
| Accuracy — does what the criterion says | | |
| Completeness — all this slice's criteria met | | |
| Clarity — another dev understands it cold | | |
| Surgical-ness — touched only what's needed | | |
| No-placeholders | | |

**Top 1–3 fixes applied before handoff:**
1.
