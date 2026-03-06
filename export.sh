#!/bin/bash

echo 'Exporting Skills...'
cp -Rf ./skills ~/.openclaw/
echo '...done'

echo 'Exporting Agents (md files only)...'
for src_dir in workspace-*/; do
  name=$(basename "$src_dir")
  mkdir -p ~/.openclaw/"$name"
  cp -f "$src_dir/"*.md ~/.openclaw/"$name"/ 2>/dev/null || true
done
echo '...done'

echo 'Exporting Coordination files...'
mkdir -p ~/.openclaw/coordination
cp -f ./coordination/*.md ~/.openclaw/coordination/ 2>/dev/null || true
echo '...done'

echo 'Syncing agent definitions to ~/.openclaw/openclaw.json...'
MAIN_CONFIG=~/.openclaw/openclaw.json
# Ensure main config exists with an agents object
if [ ! -f "$MAIN_CONFIG" ]; then
  echo '{"agents":{}}' > "$MAIN_CONFIG"
fi
for workspace_json in workspace-*/openclaw.json; do
  if [ -f "$workspace_json" ]; then
    agent_id=$(jq -r '.agentId' "$workspace_json")
    tmp_file=$(mktemp)
    jq --argjson def "$(cat "$workspace_json")" \
      ".agents[\"$agent_id\"] = \$def" \
      "$MAIN_CONFIG" > "$tmp_file" \
      && mv "$tmp_file" "$MAIN_CONFIG"
    echo "  Updated agent '$agent_id'"
  fi
done
echo '...done'

echo 'Restarting OpenClaw gateway...'
systemctl --user restart openclaw
echo '...done'
