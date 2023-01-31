# ------------------------------------------------------------------------------------------------------------
# NOTE: THIS FILE IS AUTO GENERATED AND MANAGED BY https://github.com/zendesk/cicd-toolkit
#
# You can regenerate the content by running `make` in the 'cicd-toolkit' directory.
#
# MANUAL CHANGES TO THIS FILE MAY RESULT IN INCORRECT BEHAVIOUR, AND WILL BE LOST IF THE CODE IS REGENERATED.
# ------------------------------------------------------------------------------------------------------------
{
  groups: [
    {
      name: 'statsd_kubernetes',
      values: import 'github.com/zendesk/config-service-data/data/shared_env_groups/statsd_kubernetes.json',
    },
    {
      name: 'zendesk_pod_id',
      values: import 'github.com/zendesk/config-service-data/data/shared_env_groups/zendesk_pod_id.json',
    },
  ]
}
