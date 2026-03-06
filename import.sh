#!/bin/bash

echo 'Importing Skills...'
cp -Rf ~/.openclaw/skills .
echo '...done'

echo 'Importing Agents (md files only)...'
for src_dir in ~/.openclaw/workspace-*/; do
  name=$(basename "$src_dir")
  mkdir -p "./$name"
  cp -f "$src_dir/"*.md "./$name/" 2>/dev/null || true
done
echo '...done'

echo 'Importing Coordination files...'
mkdir -p ./coordination
cp -f ~/.openclaw/coordination/*.md ./coordination/ 2>/dev/null || true
echo '...done'

echo 'Importing agent definitions from ~/.openclaw/openclaw.json...'
MAIN_CONFIG=~/.openclaw/openclaw.json
if [ -f "$MAIN_CONFIG" ]; then
  for workspace_json in workspace-*/openclaw.json; do
    if [ -f "$workspace_json" ]; then
      agent_id=$(jq -r '.agentId' "$workspace_json")
      agent_def=$(jq --arg id "$agent_id" '.agents[$id] // empty' "$MAIN_CONFIG")
      if [ -n "$agent_def" ]; then
        echo "$agent_def" > "$workspace_json"
        echo "  Updated $workspace_json from main openclaw.json"
      fi
    fi
  done
else
  echo '  ~/.openclaw/openclaw.json not found — skipping agent definition import'
fi
echo '...done'

