# ------------------------------------------------------------------------------------------------------------
# NOTE: THIS FILE WAS GENERATED ON INITIAL BOOTSTRAP by https://github.com/zendesk/cicd-toolkit
#
# MANUALLY CHANGING THIS FILE IS ALLOWED, BUT POTENTIALLY MAKES UPGRADES MORE DIFFICULT.
# ------------------------------------------------------------------------------------------------------------
local libtarget = import 'github.com/zendesk/cicd-toolkit/lib/target.libsonnet';
local libzd = import 'github.com/zendesk/cicd-toolkit/lib/zendesk.libsonnet';

local projectMetadata = (import 'run.libsonnet').projectMetadata;
local roles = (import 'run.libsonnet').roles;

local baseWithRoles = libzd.environmentForProjectWithRoles(projectMetadata, roles);

baseWithRoles {
  name: error 'Environment name should be set',

  params+: {
    values+: {
      // common values shared for all environments
    },
  },
}
