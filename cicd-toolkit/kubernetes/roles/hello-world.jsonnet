local libroleparams = import 'github.com/zendesk/cicd-toolkit/lib/role-params.libsonnet';
local librole = import 'github.com/zendesk/cicd-toolkit/lib/role.libsonnet';
local K8s = import 'github.com/zendesk/cicd-toolkit/jsonnet-kubernetes/lib/K8s.libsonnet';
local Istio = import 'github.com/zendesk/cicd-toolkit/jsonnet-kubernetes/lib/istio.libsonnet';

function(params={}) (

  local p = libroleparams.v1 + params {};

  local role_name = "metaflow";
  local project_name = "ml-training-pipelines";
  local hostname = p.roleVariables.hostname;

  local secrets = {
    'metaflow_service_db_pass': 'secret/db_pass',
    'metaflow_service_db_user': 'secret/db_user'
  };

  local labels = {
      'app': 'metaflow',
      'configuration-delivery': 'true',
      'temp-auth': 'enabled',
      'opa-gatekeeper.zendesk.com/run-as-non-root': 'false',
      'opa-gatekeeper.zendesk.com/pdb-requires-readiness-probe': "false"
  };

  local container = K8s.Container
                        .withName(role_name)
                        .withCommand(["metadata_service"])
                        .withPorts([
                          {
                            name: "metadata-svc",
                            containerPort: 8080,
                            protocol: "TCP",
                          },
                          {
                            name: "migration",
                            containerPort: 8080,
                            protocol: "TCP",
                          }
                        ])
                        .withEnvFromMap({
                          "STUFF": "GOES_HERE"
                        })
                        .withImage('');

  local podTemplate = K8s.PodTemplate
                        .withContainers([container])
                        .withSecretSidecarWithDefaultsFromConfigmaps(
                          secrets=secrets,
                        );


  local deployment = K8s.Deployment
                     .withName(role_name)
                     .withPodTemplate(podTemplate)
                     .withTemplateLabels(labels)
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
