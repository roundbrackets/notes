#!/bin/bash

#rvault -e corp list aws/roles
# env corp/staging/prod ?

env=corp
region=us-west-2
profile=infra-platform-dev2-admin

vault_get_sts_token --awsRole  --region us-west-2 --env corp

for i in `aws ec2 help | egrep -o '\bdescribe.*$'`; do echo "### $i ###"; aws --color=on --region us-west-2 --profile infra-platform-dev2-admin ec2 $i; done | tee cookie.txt
