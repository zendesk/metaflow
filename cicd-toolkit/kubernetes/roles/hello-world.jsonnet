local libroleparams = import 'github.com/zendesk/cicd-toolkit/lib/role-params.libsonnet';
local librole = import 'github.com/zendesk/cicd-toolkit/lib/role.libsonnet';
local K8s = import 'github.com/zendesk/cicd-toolkit/jsonnet-kubernetes/lib/K8s.libsonnet';
local Istio = import 'github.com/zendesk/cicd-toolkit/jsonnet-kubernetes/lib/istio.libsonnet';

function(params={}) (

  local p = libroleparams.v1 + params {};

  local role_name = "helow-world";
  local project_name = "ml-training-pipelines";

  local container = K8s.Container
                        .withName(role_name)
                        .withCommand(['echo', 'hello', 'world'])
                        .withImage('');

  local podTemplate = K8s.PodTemplate
                         .withTemplateName(role_name)
                         .withNamespace(project_name)
                         .withContainers([
                           container
                         ])
                         .withGracefulStop(120)
                         .withRestartPolicy('Never')
                         .withSecurityContext({
                           runAsNonRoot: true,
                           runAsUser: 1000
                         });

  local job = K8s.Job
                 .withNamespace(project_name)
                 .withTTLSecondsAfterFinished(600)
                 .withActiveDeadlineSeconds(600)
                 .withBackoffLimit(0)
                 .withPodTemplate(podTemplate){metadata+: { "generateName": p.name + "-"}};


  local manifests = [
    job
  ];

  librole.mutateRole(p, manifests)
)