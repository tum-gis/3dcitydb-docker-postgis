#!/usr/bin/env bash

# setup hooks located in current directory for a git repo ---------------------

# git hooks
hooks=('applypatch-msg' 'pre-applypatch' 'post-applypatch' 'pre-commit' \
	'prepare-commit-msg' 'commit-msg' 'post-commit' 'pre-rebase' 'post-checkout' \
	'post-merge' 'pre-push' 'pre-receive' 'update' 'post-receive' 'post-update' \
	'pre-auto-gc' 'post-rewrite')

# manage working dir
pwdBefore=$PWD
REPOROOT="$(git rev-parse --show-toplevel)"
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo

if [ -d "$REPOROOT/.git" ]; then
	echo 'Setting up hooks...'
	echo
	for i in "${hooks[@]}"
	do
    if [ -f "$i" ]; then
			printf "\t$i\t"
			ln -sfv "$PWD/$i" "$REPOROOT/.git/hooks"
		fi
	done
	echo
	echo 'Setting up hooks...done!'
else
	echo "$REPOROOT seems not to be a git repo, Doing nothing!"
fi

cd $pwdBefore
