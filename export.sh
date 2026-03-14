#!/bin/bash

WD="${1:-".zeroclaw"}"
CF="${2:-"config.toml"}"
SN="${3:-"zeroclaw.service"}"
echo "Working directory: $WD"
echo "Config file: $CF"
echo "Service name: $SN"

echo 'Exporting Skills...'
cp -Rf ./skills ~/$WD/
echo '...done'

echo 'Exporting Agents (md files only)...'
for src_dir in workspace-*/; do
  name=$(basename "$src_dir")
  mkdir -p ~/$WD/"$name"
  cp -f "$src_dir/"*.md ~/$WD/"$name"/ 2>/dev/null || true
done
echo '...done'

echo 'Exporting Coordination files...'
mkdir -p ~/$WD/coordination
cp -f ./coordination/*.md ~/$WD/coordination/ 2>/dev/null || true
echo '...done'

echo "Syncing agent definitions to ~/$WD/$CF..."
MAIN_CONFIG=~/$WD/$CF
# Ensure main config exists with an agents list array
if [ ! -f "$MAIN_CONFIG" ]; then
  echo '{"agents":{"list":[]}}' > "$MAIN_CONFIG"
fi
for workspace_json in workspace-*/$CF; do
  if [ -f "$workspace_json" ]; then
    agent_id=$(jq -r '.id' "$workspace_json")
    skills=$(jq '.skills' "$workspace_json")
    tools=$(jq '.tools' "$workspace_json")
    tmp_file=$(mktemp)
    # If agent already exists in the list, only update its skills and tools.
    # Otherwise append a minimal entry {id, skills, tools} without disturbing
    # any other attributes that may exist in the live config.
    jq --arg id "$agent_id" \
       --argjson skills "$skills" \
       --argjson tools "$tools" '
      if (.agents.list | map(.id) | index($id)) != null then
        .agents.list = [
          .agents.list[] |
          if .id == $id then
            .skills = $skills | .tools = $tools
          else
            .
          end
        ]
      else
        .agents.list += [{"id": $id, "skills": $skills, "tools": $tools}]
      end
    ' "$MAIN_CONFIG" > "$tmp_file" \
      && mv "$tmp_file" "$MAIN_CONFIG"
    echo "  Updated agent '$agent_id'"
  fi
done
echo '...done'

echo "Restarting $SN..."
systemctl --user restart $SN
echo '...done'
