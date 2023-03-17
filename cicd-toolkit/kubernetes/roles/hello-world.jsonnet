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
    'metaflow-service-db-password': '/secrets/numbat/db_password'
  };


  local labels = {
      'app': 'metaflow',
      'configuration-delivery': 'true',
      'temp-auth': 'enabled',
      'istio-injection': 'enabled',
      'opa-gatekeeper.zendesk.com/run-as-non-root': 'false',
      'opa-gatekeeper.zendesk.com/pdb-requires-readiness-probe': 'false',
      'sidecar.istio.io/inject': 'true'
  };

  local container = K8s.Container
                        .withName(role_name)
                        .withCommand(["metadata_service"])
                        .withPorts([
                          {
                            name: "metadata-svc",
                            containerPort: 8080,
                            protocol: "TCP",
                          }
                        ])
                        .withEnvFromArray([
                          { name: "MF_METADATA_DB_PORT", value: "5432"},
                          { name: "MF_METADATA_DB_USER", value: "metaflow"},
                          { name: "MF_METADATA_DB_PSWD", value: "/secrets/db_password"},
                          { name: "MF_METADATA_DB_NAME", value: "metaflow"},
                          { name: "MF_METADATA_DB_HOST", value: "terraform-20230314014245304300000001.cdswufymuxfo.us-east-1.rds.amazonaws.com"},
                        ])
                        .withImage('');

  local podTemplate = K8s.PodTemplate
                        .withContainers([container])
                        .withSecretSidecarWithDefaultsFromConfigmaps(
                          vaultAddr='https://secret.zdsystest.com:8200',
                          secrets=secrets,
                        );


  local deployment = K8s.Deployment
                     .withName(role_name)
                     .withPodTemplate(podTemplate)
                     .withTemplateLabels(labels)
                     .withLabels(labels)
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
