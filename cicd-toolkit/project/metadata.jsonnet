# ------------------------------------------------------------------------------------------------------------
# NOTE: THIS FILE WAS GENERATED ON INITIAL BOOTSTRAP by https://github.com/zendesk/cicd-toolkit
#
# MANUALLY CHANGING THIS FILE IS ALLOWED, BUT POTENTIALLY MAKES UPGRADES MORE DIFFICULT.
# ------------------------------------------------------------------------------------------------------------
local libprojectmetadata = import 'github.com/zendesk/cicd-toolkit/lib/project-metadata.libsonnet';

libprojectmetadata.v1 {
  project+: {
    name: 'default-bootstrap-project',
  },
  team+: {
    name: 'default-team',
    region: 'EMEA',
  },
  product+: {
    name: 'default-product',
  },
  repository+: {
    defaultBranch: 'default-branch',
  },
  githubWorkflows+: {
    buildAndRelease+: {
      buildEcrImages+: {
        # 2022-09: this feature is experimental and subject to changes in near future due to upcoming image retention policy
        enabled: false, 
      },
      createAndDeployRelease+: {
        enabled: true,
      },
      tagAndRelease+: {
        enabled: true,
      },
      opaManifestValidation+: {
        enabled: true,
      },
    },
  },
}
