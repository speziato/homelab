#!/bin/sh
set -eu
M=/mise/bin/mise

$M trust >/dev/null; $M trust "mise.toml" >/dev/null
$M install --locked yq helm kustomize kubectl github:patrickdappollonio/kubectl-slice github:AGWA/git-crypt

# unlock needs a clean tree: park the bump, unlock, restore it, then regenerate
if ! git config --get filter.git-crypt-workload.smudge >/dev/null; then
  git stash push -q
  $M exec -- git-crypt unlock /secrets/git-crypt.key
  git stash pop -q
fi

$M run maintenance
