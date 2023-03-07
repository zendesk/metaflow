{
  all: {
    secretPullerType: 'secret-sidecar',
    injectIstioProxy: true,
  },
  'internaltools-staging-use1-chef': {
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
