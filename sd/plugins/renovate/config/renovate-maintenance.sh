#!/bin/sh
set -eu

mise trust >/dev/null; mise trust "mise.toml" >/dev/null
mise install --locked yq helm kustomize kubectl github:patrickdappollonio/kubectl-slice github:AGWA/git-crypt

# unlock needs a clean tree: park the bump, unlock, restore it, then regenerate
if ! git config --get filter.git-crypt-workload.smudge >/dev/null; then
  git stash push -q
  mise exec -- git-crypt unlock /secrets/git-crypt.key
  git stash pop -q
fi

mise run maintenance
