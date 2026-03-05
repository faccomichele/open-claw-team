#!/bin/bash

echo 'Importing Skills...'
cp -Rf ~/.openclaw/skills/ ./skills
echo '...done'

echo 'Importing Agents...'
cp -f ~/.openclaw/workspace-*/*.md ./workspace-*/
echo '...done'

