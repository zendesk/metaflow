# ------------------------------------------------------------------------------------------------------------
# NOTE: THIS FILE WAS GENERATED ON INITIAL BOOTSTRAP by https://github.com/zendesk/cicd-toolkit
#
# MANUALLY CHANGING THIS FILE IS ALLOWED, BUT POTENTIALLY MAKES UPGRADES MORE DIFFICULT.
# ------------------------------------------------------------------------------------------------------------
local libentrypoints = import 'github.com/zendesk/cicd-toolkit/lib/entrypoints.libsonnet';

// This initializes the application, with the desired entrypoints for configuration expansion.
// All arguments here, is optional as we inspect the local filesystem for project inputs according
// to the recommended directory structure.
//
// See https://github.com/zendesk/cicd-toolkit#directory-structure for details.
libentrypoints()
