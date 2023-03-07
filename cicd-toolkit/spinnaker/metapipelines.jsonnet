local staging = import 'github.com/zendesk/cicd-toolkit/lib/metapipelines/internaltools-staging-chef.libsonnet';
local production = import 'github.com/zendesk/cicd-toolkit/lib/metapipelines/internaltools-production-chef.libsonnet';
local cp = import 'create-pipes.libsonnet';

{
  'ml-training-pipelines-staging': staging['internaltools-staging-chef'] {
    name: 'ml-training-pipelines',
    createRollbackPipeline: false,
    createLockablePipeline: true,
    phases: [
      {
        name: 'Phase 1: Staging',
        targets: [
          'internaltools-staging-use1-chef',
        ],
      },
    ],
  },
  'ml-training-pipelines-production': production['internaltools-production-chef'] {
    name: 'ml-training-pipelines',
    createRollbackPipeline: false,
    createLockablePipeline: true,
    phases: [
      {
        name: 'Phase 1: Production',
        targets: [
          'internaltools-production-use1-chef',
        ],
      },
    ],
  },
  
}
