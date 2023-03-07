// production internaltools cluster, comment out the following one line to disable.
local internaltoolsproductionuse1chef = import 'github.com/zendesk/cicd-toolkit/lib/metapipelines/internaltools-production-use1-chef.libsonnet';
// staging internaltools cluster, comment out the following two lines to disable.
local internaltoolsstaginguse1chef = import 'github.com/zendesk/cicd-toolkit/lib/metapipelines/internaltools-staging-use1-chef.libsonnet';

internaltoolsproductionuse1chef + internaltoolsstaginguse1chef
