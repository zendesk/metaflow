# ------------------------------------------------------------------------------------------------------------
# NOTE: THIS FILE IS GENERATED ON SELF-UPDATE BY https://github.com/zendesk/cicd-toolkit
#
# You can regenerate the content by running `make self-update` in the 'cicd-toolkit' directory.
#
# MANUAL CHANGES TO THIS FILE MAY RESULT IN INCORRECT BEHAVIOUR, AND WILL BE LOST IF THE CODE IS REGENERATED.
# ------------------------------------------------------------------------------------------------------------
export PROJECT_ROOT := ..
export APPLICATION_ROOT_DIR := cicd-toolkit

TARGET := pod998
ROLE := app-server
OUTPUT_FORMAT := json
UPDATE_MARKER := $(shell date -u)
CICD_TOOLKIT_REPOSITORY_URL := https://github.com/zendesk/cicd-toolkit

# Regenerate files with contents of vendor directory
update-boilerplate: vendor
	# first we try running the parallel version of boilerplate updating, falling back to non parallel if it fails
	(appconfig show --all-components --env cicd-boilerplate || \
		appconfig show -e '(import "run.libsonnet")["boilerplate:update"].files') | \
		appconfig run boilerplate:component-manifest --tla-code manifest='(import "/dev/stdin")' | \
		(cd $(PROJECT_ROOT) && ./$(APPLICATION_ROOT_DIR)/render)

# Vendir sync to latest version and run update-boilerplate
vendor-update:
	vendir sync
	$(MAKE) update-boilerplate

# Update contents of vendor directory to version in lock file
vendor: vendir.lock.yml
	vendir sync --locked

# Updates cicd-toolkit and regenerates files
self-update: VERSION :=
self-update: BUNDLE_URL := "$(subst https://,,$(CICD_TOOLKIT_REPOSITORY_URL))//jsonnet?ref=$(VERSION)"
self-update: BUNDLE_JSONNET_PATH := "."
self-update:
	appconfig run --bundle.url=$(BUNDLE_URL) --bundle.jsonnet-path=$(BUNDLE_JSONNET_PATH) boilerplate:self-update | \
		appconfig manifest --output-dir . --state-file .generated.yml --log-level debug
	SELF_UPDATE_INVOKED_VIA_MAKE=true ./scripts/self-update.sh $(VERSION)

# Updates config-service-data vendir lock and runs make
update-shared-env-groups:
	vendir sync -d vendor/github.com/zendesk/config-service-data
	$(MAKE)

# Prints values currently set
values:
	@appconfig show --env $(TARGET) -e "std.extVar('appconfig').params.values" -o $(OUTPUT_FORMAT)

# Prints out the kubernetes roles
kubernetes-roles:
	@appconfig run --env $(TARGET) kubernetes:roles -o $(OUTPUT_FORMAT)

# Prints the parameters for a kubernetes role (defaults to app-server)
kubernetes-role-parameters:
	@appconfig run debug:role-params -A role=$(ROLE) --env $(TARGET) -o $(OUTPUT_FORMAT)

# Prints out a kubernetes role (defaults to app-server)
kubernetes-single-role:
	@appconfig show --env $(TARGET) -c $(ROLE) -o $(OUTPUT_FORMAT)

# Prints out spinnaker pipeline for TARGET (defaults to pod998)
spinnaker-pipelines:
	@appconfig run --env $(TARGET) spinnaker:pipelines-for-env

# Gets the values set, updates boilerplate, runs either kubernetes roles and generates spinnaker pipelines
.PHONY: values update-boilerplate kubernetes-roles spinnaker-pipelines
