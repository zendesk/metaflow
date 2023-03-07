# ------------------------------------------------------------------------------------------------------------
# NOTE: THIS FILE WAS GENERATED ON INITIAL BOOTSTRAP by https://github.com/zendesk/cicd-toolkit
#
# MANUALLY CHANGING THIS FILE IS ALLOWED, BUT POTENTIALLY MAKES UPGRADES MORE DIFFICULT.
# ------------------------------------------------------------------------------------------------------------
// This file exports a function, which is used for returning the map of secret paths
// from short name to fully expanded.
//
// The short name is usually found in the kubernetes manifests, to make them agnostic
// and the resolved names are then replaced when expanding the configuration.

local libtarget = import 'github.com/zendesk/cicd-toolkit/lib/target.libsonnet';
local projectMetadata = (import 'run.libsonnet').projectMetadata;

function(target) (
  local t = libtarget.targets[target];
  local env = t.environment;

  local params = {
    target: target,
    env: env,
    project: projectMetadata.project.name,
  };

  // your project level secrets here in below format
  //
  // The keys in the 'params' object above will be interpolated for each value in the
  // object, so you can reference environment/partition keys in a generic way.
  //
  // Available interpolations:
  //
  // - %(env)s - the environment name
  // - %(project)s - the project name
  // - %(target)s - the target/partition name
  //
  // Example:
  // {
  //   my_secret: '%(env)s/%(target)s/path_in_vault'
  // }
  //
  // will result in
  //
  // {
  //   my_secret: 'staging/pod998/path_in_vault'
  // }
  local secrets = {

  };

  std.mapWithKey(
    function(k, v) v % params,
    secrets,
  )
)
