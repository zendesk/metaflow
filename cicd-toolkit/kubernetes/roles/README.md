# ------------------------------------------------------------------------------------------------------------
# NOTE: THIS FILE WAS GENERATED ON INITIAL BOOTSTRAP by https://github.com/zendesk/cicd-toolkit
#
# MANUALLY CHANGING THIS FILE IS ALLOWED, BUT POTENTIALLY MAKES UPGRADES MORE DIFFICULT.
# ------------------------------------------------------------------------------------------------------------
# Default Kubernetes Roles

Files in this directory with a `.jsonnet` suffix will be automatically imported as default roles for your deploy.

## Your first role

If you create file called `console.jsonnet` in this directory the rendered role output will

## Example `console.jsonnet` role:

```
local libroleparams = import 'github.com/zendesk/cicd-toolkit/lib/role-params.libsonnet';
local librole = import 'github.com/zendesk/cicd-toolkit/lib/role.libsonnet';

function(params={}) (

  local p = libroleparams.v1 + params {};

  local manifests = [
    {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      metadata: {
        name: p.name,
      },
      spec: {
        replicas: 0,
        selector: {
          matchLabels: {
            project: p.project,
            role: p.name,
          },
        },
        template: {
          metadata: {
            labels: {
              project: p.project,
              role: p.name,
              team: p.team,
            },
          },
          spec: {
            containers: [
              {
                image: p.image,
                name: p.name,
                command: [
                  'tail',
                  '-f',
                  '/dev/null',
                ],
              },
            ],
          },
        },
      },
    },
  ];

  librole.mutateRole(p, manifests)
)
```

The above example console can be created by running the below command in your application root (usually `cicd-toolkit`):

```
$ appconfig show -e "(importstr 'github.com/zendesk/cicd-toolkit/lib/bootstrap/templates/kubernetes/roles/console.jsonnet')" | jq -r > kubernetes/roles/console.jsonnet
```

## Rendering role output

```
$ appconfig run kubernetes:roles --env pod998
```

## Rendering a single role

```
$ appconfig run kubernetes:roles --env pod998 -A role=console
```

## Validating kubernetes role output

```
$ appconfig run kubernetes:validate-roles-kubeval --env pod998
[
   {
      "errors": [ ],
      "filename": "kubeval-all-roles-pod998.yml",
      "kind": "Deployment",
      "status": "valid"
   }
]
```
