{
  all: {
    secretPullerType: 'secret-sidecar',
    injectIstioProxy: true,
  },
  'internaltools-staging-use1-chef': {
    roleVariables: {
      hostname: 'ml-training-pipelines.internaltools-staging-use1-chef.zdmesh.io',
    },
    replicas: 1,
    requests: {
      cpu: '1.0',
      memory: '900Mi',
    },
    limits: {
      cpu: '1.0',
      memory: '900Mi',
    },
  },
  'internaltools-production-use1-chef': {
    roleVariables: {
      hostname: 'ml-training-pipelines.internaltools-production-use1-chef.zdmesh.io',
    },
    replicas: 1,
    requests: {
      cpu: '1.0',
      memory: '900Mi',
    },
    limits: {
      cpu: '1.0',
      memory: '900Mi',
    },
  },
}
