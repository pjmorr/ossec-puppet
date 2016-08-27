#!/bin/bash
apt-get update
apt-get -y install rubygems
gem install dpl


#s3
pwd
cd pkg
pwd
dpl --provider=s3 --access_key_id=$UBEROPS_AWS_SECRET_ACCESS_KEY --secret_access_key=$UBEROPS_AWS_ACCESS_KEY_ID --bucket=$S3_BUCKET --skip_cleanup