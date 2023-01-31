#!/usr/bin/env bash
# ------------------------------------------------------------------------------------------------------------
# NOTE: THIS FILE WAS GENERATED ON INITIAL BOOTSTRAP by https://github.com/zendesk/cicd-toolkit
#
# MANUALLY CHANGING THIS FILE IS ALLOWED, BUT POTENTIALLY MAKES UPGRADES MORE DIFFICULT.
# ------------------------------------------------------------------------------------------------------------

set -euo pipefail

readonly root="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

git_root="$(git rev-parse --show-toplevel)"

cd "$git_root" && \
  git add --all
