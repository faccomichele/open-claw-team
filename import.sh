#!/bin/bash

echo 'Importing Skills...'
cp -Rf ~/.openclaw/skills/ ./skills
echo '...done'

echo 'Importing Agents...'
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

