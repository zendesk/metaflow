local libroleparams = import 'github.com/zendesk/cicd-toolkit/lib/role-params.libsonnet';
local librole = import 'github.com/zendesk/cicd-toolkit/lib/role.libsonnet';
local K8s = import 'github.com/zendesk/cicd-toolkit/jsonnet-kubernetes/lib/K8s.libsonnet';
local Istio = import 'github.com/zendesk/cicd-toolkit/jsonnet-kubernetes/lib/istio.libsonnet';

function(params={}) (

  local p = libroleparams.v1 + params {};

  local role_name = "metaflow-service";
  local project_name = "ml-training-pipelines";
  local hostname = p.roleVariables.hostname;


  local container = K8s.Container
                        .withName(role_name)
                        .withCommand(["curl", "localhost:8080/ping"])
                        .withSecurityContext({
                             runAsUser: 65534,
                             runAsGroup:1000
                         })
                        .withPorts([
                          {
                            name: "metadata-svc",
                            containerPort: 8080,
                            protocol: "TCP",
                          },
                          {
                            name: "migration-service",
                            containerPort: 8080,
                            protocol: "TCP",
                          }
                        ])
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
                    targetPort: 'metadata-svc',
                  }])
                  .withType("ClusterIP")
                  .forDeployment(deployment);

  local virtual_service = Istio.VirtualService
                          .withName(role_name)
                          .withHosts([role_name, hostname])
                          .withGateways(["ml-experimentation-tracker/mlflow-write-access"]);

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
    virtual_service
  ];

  librole.mutateRole(p, manifests)
)
