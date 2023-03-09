local libroleparams = import 'github.com/zendesk/cicd-toolkit/lib/role-params.libsonnet';
local librole = import 'github.com/zendesk/cicd-toolkit/lib/role.libsonnet';
local K8s = import 'github.com/zendesk/cicd-toolkit/jsonnet-kubernetes/lib/K8s.libsonnet';
local Istio = import 'github.com/zendesk/cicd-toolkit/jsonnet-kubernetes/lib/istio.libsonnet';

function(params={}) (

  local p = libroleparams.v1 + params {};

  local role_name = "metaflow-service";
  local project_name = "ml-training-pipelines";
  local hostname = p.roleVariables.hostname;

  local istio_gateway = Istio.Gateway
                        .withName(role_name)
                        .withIstioSelector("ingressgateway")
                        .withServers([{
                          hosts: [hostname],
                          port: {
                            name: "https",
                            number: 443,
                            protocol: "HTTPS",
                          },
                          tls: {
                            mode: "MUTUAL",
                            credentialName: "ml-experimentation-tracker" # Istio assumes CA cert is secret under ml-experimentation-tracker-cacert
                          },
                        }]);

  local container = K8s.Container
                        .withName(role_name)
                        .withCommand(['echo', 'hello'])
                        .withSecurityContext({
                             runAsUser: 65534,
                             runAsGroup:1000
                         })
                        .withPorts([{
                          name: "http-port",
                          containerPort: 8000,
                          protocol: "TCP",
                        }])
                        .withEnvFromMap({
                          "STUFF": "GOES_HERE"
                        })
                        .withImage('');

  local deployment = K8s.Deployment
                     .withName(role_name)
                     .withContainers([container])
                     .withTemplateLabels({
                       'temp-auth': 'enabled',
                       'configuration-delivery': 'true',
                       'app': 'metadata-service'
                     })
                     .withMatchLabelsSelector({
                       project: project_name,
                       role: role_name,
                     });

  local service = K8s.Service
                  .withName(role_name)
                  .withPorts([{
                    name: "http",
                    port: 8080,
                    targetPort: 'http-port',
                  }])
                  .withType("ClusterIP")
                  .forDeployment(deployment);

  local virtual_service = Istio.VirtualService
                          .withName(role_name)
                          .withHosts([role_name, hostname])
                          .withGateways([p.namespace + "/" + istio_gateway.metadata.name]);

  local auth_policy = Istio.AuthorizationPolicy
                      .withName(p.name + "-auth-policy")
                      .withWorkloadSelector({
                        matchLabels: {
                          project: project_name,
                          role: role_name,
                        }
                      })
                      .withRules([{
                        from: [{
                          source: {
                            namespaces: ["istio-gateways", "ml-training-pipelines"]
                          }
                        }],
                      }]);

  local manifests = [
    deployment,
    auth_policy,
    service,
    virtual_service,
    istio_gateway
  ];

  librole.mutateRole(p, manifests)
)
