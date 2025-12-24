#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cp "$repo_root/languages/iris/highlights_dim_parens.scm" "$repo_root/languages/iris/highlights.scm"
echo "Parens highlighting set to dim. Restart Zed or reload the extension."
