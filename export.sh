#!/bin/bash

echo 'Exporting Skills...'
cp -Rf ./skills ~/.openclaw/
echo '...done'

echo 'Exporting Agents...'
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

echo 'Restarting OpenClaw gateway...'
systemctl --user restart openclaw
echo '...done'
