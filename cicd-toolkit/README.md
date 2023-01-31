# ------------------------------------------------------------------------------------------------------------
# NOTE: THIS FILE WAS GENERATED ON INITIAL BOOTSTRAP by https://github.com/zendesk/cicd-toolkit
#
# MANUALLY CHANGING THIS FILE IS ALLOWED, BUT POTENTIALLY MAKES UPGRADES MORE DIFFICULT.
# ------------------------------------------------------------------------------------------------------------
# cicd-toolkit -- getting started guide

cicd-toolkit is a toolkit for assisting in generating the deployment artifacts that are required
to deploy your application.

You will mostly need `appconfig` to expand local configuration. See [dependencies](#dependencies) section on how to get that installed.

There's also a `cicd-toolkit` wrapper container available, so for every `appconfig` command, you can replace it with:

```
$ zdi cicd-toolkit -u $project_name appconfig run $args
```

See the [cicd-toolkit docs](https://github.com/zendesk/cicd-toolkit#zdi-wrapper-usage) for more.

## Directory structure

The directory structure of an application looks like below:

An example of an app implementation can be found in [examples/example-project](https://github.com/zendesk/cicd-toolkit/tree/master/examples/example-project) folder inside the cicd-toolkit project itself.

```
$ tree cicd-toolkit/
├── Makefile
├── README.md
├── appconfig.yml
├── environments # your environments, *.jsonnet files are by default automatically picked up and processed
│   ├── common.libsonnet
│   ├── <ENVIRONMENT>.jsonnet
│   └── staging.jsonnet
├── kubernetes
│   ├── resources # resource configuration for your individual roles. Here you can vary certain customizations at the environment/partition level.
│   └── roles # role configuration, where by default each file is being consumed expecting to return a role function
├── lib
│   ├── environment.libsonnet # entrypoint for defining your environments. By default it will emit the default environment setup.
│   ├── run.libsonnet # the entrypoint for the application. This file exposes all the `run` functions.
│   └── shared-env-groups.libsonnet # generated files for shared environment variable group configuration files.
│─ project
│   ├── env-vars.jsonnet # environment variables varied by scope (e.g. environment/partition)
│   ├── metadata.jsonnet # project metadata which contains environment neutral information for the project.
│   ├── secrets.jsonnet # secret mapping that returns a map of short name -> full vault path for the project secrets.
│─ spinnaker
│   ├── custom-pipelines.jsonnet # custom pipelines
│   └── metapipelines.jsonnet # metapipelines which defines the standard rollout order for your project
```

## Schemas

cicd-toolkit uses schemas for defining most of its well-known inputs/outputs. These are currently defined by JSON schema.

The primary schemas are documented in the [docs/schemas/](https://github.com/zendesk/cicd-toolkit/tree/master/docs/schemas) folder in upstream cicd-toolkit project.

Example schema documentation for [projectMetadata.v1](https://github.com/zendesk/cicd-toolkit/blob/master/docs/schemas/projectMetadata.v1.md).

### Core schemas for understanding the input/output model of cicd-toolkit

#### ProjectMetadata

The project metadata contains metadata information about the project.

The full schema documentation can be found at the [projectMetadata.v1](https://github.com/zendesk/cicd-toolkit/blob/master/docs/schemas/projectMetadata.v1.md) schema docs page.

#### EnvironmentValues

Environment values describes information which varies at the environment level.

Usually this is values at the scope of "staging" or "production".

You can inspect the environment values for a given environment by running:

```
$ appconfig run debug:values --env $env
```

#### Partition Parameters

Partition parameters are derived by applying the project's partition function to the environment values for the parent environment.

The full schema documentation can be found at the [PartitionParams.v1](https://github.com/zendesk/cicd-toolkit/blob/master/docs/schemas/params.v1.md) schema docs page.

In the case of `POD998` we would take the values from the `staging` environment and apply the function to build up the final partition parameters.

You can inspect the partition params by running:

```
$ appconfig run debug:params --env $env
```

#### RoleParameters

Role parameters describes the shared parameters that are in scope for a given role.

The full schema documentation can be found at the [RoleParameters.v1](https://github.com/zendesk/cicd-toolkit/blob/master/docs/schemas/roleParams.v1.md) schema docs page.

The values passed when evaluating a role for a given partition are expected to match the schema.

You can see what values are passed for a given role by running:

```
$ appconfig run debug:role-params -A role=$role --env $env
```

## Developing

### `appconfig` entrypoints

We provide several commands that can be used to understand the
inputs to Kubernetes roles and the configuration that goes into generating the
spinnaker pipelines/applications.

#### List environments:

  * `appconfig run environments`

#### Inspect the partition parameters for an environment (conforms to [Params.v1](https://github.com/zendesk/cicd-toolkit/blob/master/docs/schemas/params.v1.md) schema):

  * `appconfig run debug:params --env=$env`

#### Show only role parameters for a given role, for a specific environment (conforms to [RoleParams.v1](https://github.com/zendesk/cicd-toolkit/blob/master/docs/schemas/roleParams.v1.md) schema):

  * `appconfig run debug:role-params -A role=$role --env=$env`

#### Show list of roles for an environment

  * `appconfig run debug:roles --env=$env`

#### Show which PODs are configured for the environment

  * `appconfig run zendesk:pods --env=$env`

### Add environment variables

For environment variables that are expected to be applied to all roles of your project, you add values in
your project's `cicd-toolkit/project/env-vars.jsonnet` file.

The file is at the top level a simple object, with the keys `vars` that should evaluate to an object, where
the keys are the scope and the values are objects of environment value key/pairs.

```
{
  vars: {
    common: {
			MY_COMMON_ENV_VAR: 'Common value',
		},
		pod998: {
			MY_POD998_ONLY_VARIABLE: 'I will only be set for POD998',
		},
	}
```

### Working with Kubernetes manifests

To render all the Kubernetes manifests you can run this command and it
will output exactly what we would expect as the artifacts in the `-deploy` tags/branches.

``` shell
appconfig run kubernetes:roles-all-pods-manifest --multi ../kubernetes/manifests --format yaml --documents
```

## Adding a new role to your project

Adding a role consists of a few steps, that depends on the setup of your project:

* If your project usually defines kubernetes roles in YAML inside the top level `kubernetes/` folder, it is
advised that you start by adding your role configuration in a similar way.

* Add the role function in `kubernetes/roles/$role.jsonnet`

In case you write your partial role definitions by plain YAML you would add a wrapping role function similar to:

(Replace the `$your_role_path.yml` with the actual name of your role's YAML)

```
local parseYaml = std.native('parseYaml');
local libroleparams = import 'github.com/zendesk/cicd-toolkit/lib/role-params.libsonnet';
local librole = import 'github.com/zendesk/cicd-toolkit/lib/role.libsonnet';

function(params={}) (
  local p = libroleparams.v1 + params {};
  local manifests = parseYaml(importstr '$your_role_path.yml');

  librole.mutateRole(p, manifests)
)
```

Or however you want to express your role function. The only requirement is that it is a function that takes `params` as its only argument, and
returns a list of kubernetes objects as its output.

* Add role resource configuration in `kubernetes/resources/$role.jsonnet` file.

This file is an object scoped by the environment/partition with values to use for the role.

Example resource config for a `console` role which tweaks its kubernetes cpu limit in `production`.

To determine which values you can add here, consult the schema documentation for the `deployGroupRoles` [schema](https://github.com/zendesk/cicd-toolkit/blob/master/docs/schemas/params.v1.md#deployGroupRoles).

```
{
  all: {
    autoscaled: false,
    injectIstioProxy: true,
    limits: {
      cpu: '0.1',
      memory: '1907Mi',
    },
    replicas: 0,
    requests: {
      cpu: '0.1',
      memory: '1907Mi',
    },
  },
  production: {
    limits: {
      cpu: '1',
    },
  }
```

* Regenerate spinnaker pipelines, to include your new role definition in the pipelines.

To regenerate the local pipeline configuration run below command in the root of your project.

```
$ make -C cicd-toolkit
```

* Synchronizing your pipelines into spinnaker

It is currently not allowed to do automated synchronizations of non-default
branch pipelines, towards our production spinnaker instance so it is
recommended, to add your role with `0` replicas for all environments, as a
start to trigger a pipeline change, and only afterwards change the number of
replicas you want to run.

* Merge your change, and wait for the change to take effect.

You can watch spinnaker configuration syncs happening by going to the `tasks` tab in your project.

Example for help-center: https://spinnaker.zende.sk/#/applications/help-center/tasks

## Updating cicd-toolkit and its dependencies

**Dependencies**

cicd-toolkit has two primary dependencies

  * [vendir](https://carvel.dev/vendir/) (Can be installed by `homebrew` by [tapping their repository](https://github.com/vmware-tanzu/homebrew-carvel))
  * [appconfig](https://github.com/zendesk/appconfig#quick-pitch) ([install instructions through homebrew](https://github.com/zendesk/appconfig#install-appconfig-from-homebrew), [manual binary release](https://github.com/zendesk/appconfig/releases))

> :bangbang: you WILL need to set `VENDIR_GITHUB_API_TOKEN` to a valid
> personal access token for this command to work.  The access token
> needs the scope `repo`.

To update to the latest version of cicd-toolkit run:

``` shell
./scripts/self-update.sh
```

This action will execute something equivalent to,

``` shell
vendir sync
make update-boilerplate
```

vendir is used to pull latest updates from
[config-service-data](https://github.com/zendesk/config-service-data)
and [cicd-toolkit](https://github.com/zendesk/cicd-toolkit).  Once the
latest files a present, running `make update-boilerplace` will
generate any:

- GitHub actions
- Make files
- Scripts
- Documentation

## Configuration-only releases / hotfixes

By default, changes which only touch config related paths will pull in the image digests from the
base/previous release of a change.

It works by looking at the project metadata's `repository.configOnlyPathPatterns` items, and comparing
the changes going into a PR/release, to determine if it's a configuration-only release.

If a PR is detected as config-only, we add the `cicd-toolkit-hotfix` label to the PR to indicate that we
will fast-track changes where applicable.

To check which paths are ignored for your project, you can run:

```
$ appconfig run debug:config-only-path-patterns
```

## Github Workflows

By placing **labels** on your PR you can trigger different actions.

- `update manifests` -- Generate Kubernetes files and put them on a
  branch named `<current-branch-name>-deploy` where your current
  branch name is substituted in
- `deploy` -- Trigger a deployment to staging

## Debugging jsonnet code

### Discovering the value of variables in Jsonnet

There is no REPL in Jsonnet for inspecting values in the environment, so
to inspect these values we need to modify the program.  Because
Jsonnet programs are lazy evaluated, the only way to print any value
is to replace part of the program with a method `std.trace(message,
value)` that returns value and prints message to STDOUT as a
side-effect.  This allows us to inspect any value in Jsonnet.

e.g.

To find the value of the argument `values`

``` jsonnet
local librole = import 'github.com/zendesk/cicd-toolkit/lib/role.libsonnet';
local libtarget = import 'github.com/zendesk/cicd-toolkit/lib/target.libsonnet';

function(target, values, roles={}) (
  local t = libtarget.targets[target];
  local env = t.environment;

  local shared_env_group_vars = libtarget.resolveStackObject(target, [
    import 'github.com/zendesk/config-service-data/data/shared_env_groups/statsd_kubernetes.json',
    import 'github.com/zendesk/config-service-data/data/shared_env_groups/zendesk_pod_id.json',
  ]);

  values {
    environmentVariables+: shared_env_group_vars {
    },
  }
)
```

We could do it by wrapping the use of the variable with a trace function
``` jsonnet
local librole = import 'github.com/zendesk/cicd-toolkit/lib/role.libsonnet';
local libtarget = import 'github.com/zendesk/cicd-toolkit/lib/target.libsonnet';

function(target, values, roles={}) (
  local t = libtarget.targets[target];
  local env = t.environment;

  local shared_env_group_vars = libtarget.resolveStackObject(target, [
    import 'github.com/zendesk/config-service-data/data/shared_env_groups/statsd_kubernetes.json',
    import 'github.com/zendesk/config-service-data/data/shared_env_groups/zendesk_pod_id.json',
  ]);

  std.trace(std.toString(values), values) {
    environmentVariables+: shared_env_group_vars {
    },
  }
)

```

If you want to print any variable you could change that line to anything you like, for example

``` jsonnet
  std.trace(std.toString(target), values) {
```

It's just important that the trace function is evaluated in the
context with variable you're interested in.

For a thorough introduction to the jsonnet language, their [online tutorial](https://jsonnet.org/learning/tutorial.html) is highly recommended.
