#!/usr/bin/env bash
# Rebuilds dist/<skill>.zip for every skill, for uploading to the Claude app
# (claude.ai > Settings > Capabilities > Skills). Run from anywhere:
#   ./scripts/build-zips.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/dist"
for skill_dir in "$ROOT"/plugins/*/skills/*/; do
  skill="$(basename "$skill_dir")"
  rm -f "$ROOT/dist/$skill.zip"
  (cd "$(dirname "$skill_dir")" && zip -rq "$ROOT/dist/$skill.zip" "$skill" -x '*.DS_Store')
  echo "Built dist/$skill.zip"
done
