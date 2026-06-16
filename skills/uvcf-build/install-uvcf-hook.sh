#!/usr/bin/env bash
# Installs the Ultimate VCF pre-commit gate into a target git repo.
# Idempotent. Chains onto an existing hook / husky setup instead of clobbering.
#
# Usage:  bash install-uvcf-hook.sh [/path/to/target/repo]   (default: cwd)
#
# It copies uvcf-precommit.sh (sibling of this script) to
# <repo>/.uvcf/hooks/uvcf-precommit.sh and wires it in:
#   - husky repo (.husky/ exists)  → appends a guarded call to .husky/pre-commit
#   - plain repo                   → appends a guarded call to .git/hooks/pre-commit
# Remove later by deleting the marked line + .uvcf/hooks/.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/uvcf-precommit.sh"
[ -f "$SRC" ] || { echo "install: uvcf-precommit.sh not found next to this script" >&2; exit 1; }

TARGET="${1:-$(pwd)}"
cd "$TARGET"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "install: '$TARGET' is not a git repo" >&2; exit 1; }
cd "$ROOT"

mkdir -p .uvcf/hooks
cp "$SRC" .uvcf/hooks/uvcf-precommit.sh
chmod +x .uvcf/hooks/uvcf-precommit.sh

MARK="# >>> uvcf pre-commit gate >>>"
CALL='bash "$(git rev-parse --show-toplevel)/.uvcf/hooks/uvcf-precommit.sh" || exit 1'

wire () {  # $1 = hook file
  local f="$1"
  if [ -f "$f" ] && grep -qF "$MARK" "$f"; then echo "install: already wired in $f"; return; fi
  if [ ! -f "$f" ]; then printf '#!/usr/bin/env bash\n' > "$f"; chmod +x "$f"; fi
  printf '\n%s\n%s\n# <<< uvcf pre-commit gate <<<\n' "$MARK" "$CALL" >> "$f"
  echo "install: wired uvcf gate into $f"
}

if [ -d .husky ]; then
  wire ".husky/pre-commit"
else
  wire ".git/hooks/pre-commit"
fi
echo "install: done. The gate fires only when a .vcf/<slug> build slice is awaiting confirm."
echo "         Bypass any commit with: git commit --no-verify"
