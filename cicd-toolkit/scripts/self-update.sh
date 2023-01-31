#!/usr/bin/env bash
# ------------------------------------------------------------------------------------------------------------
# NOTE: THIS FILE WAS GENERATED ON INITIAL BOOTSTRAP by https://github.com/zendesk/cicd-toolkit
#
# MANUALLY CHANGING THIS FILE IS ALLOWED, BUT POTENTIALLY MAKES UPGRADES MORE DIFFICULT.
# ------------------------------------------------------------------------------------------------------------
set -euo pipefail

version="${1:-""}"

SKIP_SYNC="${SKIP_SYNC:-""}"
CICD_TOOLKIT_APPLICATION_ROOT="${CICD_TOOLKIT_APPLICATION_ROOT:-""}"
PROJECT_ROOT="${PROJECT_ROOT:-""}"
CICD_TOOLKIT_REPOSITORY_URL="${CICD_TOOLKIT_REPOSITORY_URL:-"https://github.com/zendesk/cicd-toolkit"}"

if [ -z "$version" ]; then
  echo >&2 "Determining latest release of cicd-toolkit ...."
  if ! tag_refs=$(git ls-remote --refs --sort="-version:refname" --tags "$CICD_TOOLKIT_REPOSITORY_URL"); then
    echo >&2 'Failed determining latest release -- run again with a fixed version: make self-update VERSION=$desired-version'
    exit 1
  fi
  latest_release_tag_ref="$(echo "$tag_refs" | head -n1 | cut -f2)"
  version="${latest_release_tag_ref#refs/tags/}"

  echo >&2 "Found latest release as: $version"
fi

SELF_UPDATE_INVOKED_VIA_MAKE="${SELF_UPDATE_INVOKED_VIA_MAKE:-""}"
if [ -z "$SELF_UPDATE_INVOKED_VIA_MAKE" ]; then
  echo >&2 "====================="
  echo >&2 "ERROR: To ensure a proper upgrade, please run me via 'make self-update VERSION="$version"' rather than running the script yourself."
  echo >&2 "====================="
  exit 1
fi

bash_src="${BASH_SOURCE:-""}"

if [ -z "$CICD_TOOLKIT_APPLICATION_ROOT" ]; then
  # look for cicd-toolkit installation to update ...
  if [ -f "appconfig.yml" ]; then
    CICD_TOOLKIT_APPLICATION_ROOT="$PWD"
  elif [ -f "cicd-toolkit/appconfig.yml" ]; then
    CICD_TOOLKIT_APPLICATION_ROOT="$PWD/cicd-toolkit"
  elif [ -n "$bash_src" ]; then
    CICD_TOOLKIT_APPLICATION_ROOT="$(cd "$( dirname "${bash_src}" )/.." && pwd)"
  else
    echo >&2 "fatal: Failed detecting cicd-toolkit installation - aborting self-update ..."
    exit 1
  fi
fi

if [ -z "$PROJECT_ROOT" ]; then
  if ! PROJECT_ROOT="$(git rev-parse --show-cdup)"; then
    echo >&2 "Failed determining project root, set PROJECT_ROOT to override auto detection -- aborting!"
    exit 1
  fi
fi

GITHUB_TOKEN="${GITHUB_TOKEN:-"${VENDIR_GITHUB_API_TOKEN:-""}"}"
VENDIR_GITHUB_API_TOKEN="${VENDIR_GITHUB_API_TOKEN:-"${GITHUB_TOKEN:-""}"}"

pushd "$CICD_TOOLKIT_APPLICATION_ROOT" >/dev/null

if [ -r vendir.yml ]; then

  vendir_content="$(cat vendir.yml)"
  do_migrate="$(echo "$vendir_content" | grep 'cicd-toolkit_\*.tar.gz' || true)"

  if [ -n "$do_migrate" ]; then
    echo >&2 "=================================================================="
    echo >&2 "Running one-time migration to bundleless configuration format ...."
    echo >&2 "=================================================================="

    updated_vendir_content="$(echo "$vendir_content" | \
      (
        cd $PROJECT_ROOT && appconfig show -A version="$version" -A repository_url="$CICD_TOOLKIT_REPOSITORY_URL" -o yaml -e "
        local parseYaml = std.native('parseYaml');

        function(version, repository_url) (
          local content = parseYaml(importstr '/dev/stdin')[0];

          local patchGitRepositoryReference(directories) = [
            if dir.path == 'vendor' then
              dir {
                contents: [{
                  path: 'cicd-toolkit',
                  git: {
                    url: repository_url,
                    ref: version,
                    depth: 1,
                  },
                  includePaths: [
                    'jsonnet/**/*',
                  ],
                }]
              }
            else
              dir
            for dir in directories
          ];

          content {
            directories: patchGitRepositoryReference(super.directories)
          }
        )
    "))"

    echo >&2 "Updating vendir.yml with migrated configuration"
    if ! echo "$updated_vendir_content" > "vendir.yml"; then
      echo >&2 "Failed writing updated vendir.yml ..."
    fi

    echo >&2 "Cleaning out cicd-toolkit vendor from git to remove previously committed vendored dependencies ..."
    git rm -r "vendor" || true

    echo >&2 "Running vendir sync to finish migration and pull in new version of cicd-toolkit ..."
    vendir sync -d vendor/cicd-toolkit

    echo >&2 "Update remaining dependencies with versions from lockfile ..."
    vendir sync --locked

    echo >&2 "=================================================================="
    echo >&2 "One-time migration to bundleless configuration format finished ..."
    echo >&2 "=================================================================="
  fi

else

  echo >&2 "vendir.yml not found -- skipping vendir sync"

  if [ -n "$version" ]; then
    echo >&2 "fatal: self-update to specific version without a vendir is not supported"
    exit 1
  fi

fi

vendir_content="$(cat vendir.yml)"
updated_vendir_content="$(echo "$vendir_content" | \
  (
    cd $PROJECT_ROOT && appconfig show -A version="$version" -A repository_url="$CICD_TOOLKIT_REPOSITORY_URL" -o yaml -e "
    local parseYaml = std.native('parseYaml');

    function(version, repository_url) (
      local content = parseYaml(importstr '/dev/stdin')[0];

      content {
        directories: [
          if dir.path == 'vendor' then
            dir {
              contents: [
                if c.path == 'cicd-toolkit' then
                  c {
                    git+: {
                      ref: version,
                      url: repository_url,
                    },
                  }
                else
                  c
                for c in super.contents
              ],
            }
          else
            dir
          for dir in super.directories
        ],
      }
    )
"))"

echo "$updated_vendir_content" > vendir.yml

if [ -z "$SKIP_SYNC" ]; then
  vendir sync
else
  echo >&2 "Skipping sync due to SKIP_SYNC being set ..."
fi

# All our project has rubbish in the generated directory that should be removed
rm -f generated/Makefile generated/README.md generated/appconfig.yml generated/render generated/vendir.yml
rm -rf generated/kubernetes/ generated/lib/ generated/scripts/
# cleanup previous render self update temporary files that we've left hanging around
rm -f render_self_update.*

echo >&2 "Updating boilerplate ...."

appconfig run boilerplate:update | (cd "$PROJECT_ROOT" && "$CICD_TOOLKIT_APPLICATION_ROOT/render")

popd >/dev/null

echo >&2 "All done!"
