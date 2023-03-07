#!/usr/bin/env bash
# ------------------------------------------------------------------------------------------------------------
# NOTE: THIS FILE IS GENERATED ON SELF-UPDATE BY https://github.com/zendesk/cicd-toolkit
#
# You can regenerate the content by running `make self-update` in the 'cicd-toolkit' directory.
#
# MANUAL CHANGES TO THIS FILE MAY RESULT IN INCORRECT BEHAVIOUR, AND WILL BE LOST IF THE CODE IS REGENERATED.
# ------------------------------------------------------------------------------------------------------------

set -euo pipefail

readonly root="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

git_root="$(git rev-parse --show-toplevel)"

cd "$git_root" && \
  git add --all
