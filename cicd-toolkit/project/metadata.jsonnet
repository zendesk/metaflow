# ------------------------------------------------------------------------------------------------------------
# NOTE: THIS FILE WAS GENERATED ON INITIAL BOOTSTRAP by https://github.com/zendesk/cicd-toolkit
#
# MANUALLY CHANGING THIS FILE IS ALLOWED, BUT POTENTIALLY MAKES UPGRADES MORE DIFFICULT.
# ------------------------------------------------------------------------------------------------------------
local libprojectmetadata = import 'github.com/zendesk/cicd-toolkit/lib/project-metadata.libsonnet';

libprojectmetadata.v1 {
  project+: {
    name: 'ml-training-pipelines',
  },
  team+: {
    name: 'ml-apac-trisolaris',
    region: 'APAC',
  },
  product+: {
    name: 'ml-training-pipelines',
  },
  repository+: {
    defaultBranch: 'main',
  },
  spinnaker+: {
    webhooks+: {
      branch: 'ml-training-pipelines-internaltools-staging-chef-lockable',
    },
    stages+: {
      branch: 'ml-training-pipelines-internaltools-staging-chef-lockable',
    },
  },
  githubWorkflows+: {
    buildAndRelease+: {
      buildEcrImages+: {
        # 2022-09: this feature is experimental and subject to changes in near future due to upcoming image retention policy
        enabled: true, 
        buildConfigs+: {
          'prod/zendesk/ml-training-pipelines'+: {
            dockerfile: './src/Dockerfile'
          },
          'dev/zendesk/ml-training-pipelines'+: {
            dockerfile: './src/Dockerfile'
          },
        },
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
