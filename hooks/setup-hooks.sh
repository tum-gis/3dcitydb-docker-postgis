#!/bin/bash
# run this to setup hooks for this repo

echo
if [ -d "../.git" ]; then
  echo "Setting up hooks..."
  echo
  chmod -v o+x *.sh
  echo
  ln -sfv ../../hooks/pre-commit ../.git/hooks/
  echo
  echo "Setting up hooks...done!"  
else
  echo This seems not to be a git repo! Doing nothing.
fi

echo
echo "Press ENTER to quit."
read
