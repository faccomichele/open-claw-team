#!/bin/bash

WD="${1:-"zeroclaw"}"
echo "Working directory: $WD"

echo 'Importing Skills...'
cp -Rf ~/$WD/skills .
echo '...done'

echo 'Importing Agents (md files only)...'
for src_dir in ~/$WD/workspace-*/; do
  name=$(basename "$src_dir")
  mkdir -p "./$name"
  cp -f "$src_dir/"*.md "./$name/" 2>/dev/null || true
done
echo '...done'

echo 'Importing Coordination files...'
mkdir -p ./coordination
cp -f ~/$WD/coordination/*.md ./coordination/ 2>/dev/null || true
echo '...done'

echo 'Importing agent definitions from ~/$WD/openclaw.json...'
MAIN_CONFIG=~/$WD/openclaw.json
if [ -f "$MAIN_CONFIG" ]; then
  for workspace_json in workspace-*/openclaw.json; do
    if [ -f "$workspace_json" ]; then
      agent_id=$(jq -r '.id' "$workspace_json")
      # Extract only skills and tools for this agent from the list array
      live_skills=$(jq --arg id "$agent_id" \
        '.agents.list[] | select(.id == $id) | .skills // empty' "$MAIN_CONFIG")
      live_tools=$(jq --arg id "$agent_id" \
        '.agents.list[] | select(.id == $id) | .tools // empty' "$MAIN_CONFIG")
      updated=false
      if [ -n "$live_skills" ]; then
        tmp_file=$(mktemp)
        jq --argjson skills "$live_skills" '.skills = $skills' \
          "$workspace_json" > "$tmp_file" && mv "$tmp_file" "$workspace_json"
        updated=true
      fi
      if [ -n "$live_tools" ]; then
        tmp_file=$(mktemp)
        jq --argjson tools "$live_tools" '.tools = $tools' \
          "$workspace_json" > "$tmp_file" && mv "$tmp_file" "$workspace_json"
        updated=true
      fi
      if [ "$updated" = true ]; then
        echo "  Updated skills and tools in $workspace_json from main openclaw.json"
      fi
    fi
  done
else
  echo '  ~/$WD/openclaw.json not found — skipping agent definition import'
fi
echo '...done'

