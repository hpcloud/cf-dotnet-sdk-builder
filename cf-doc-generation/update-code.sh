#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

export TASKS="tmp:clear db:drop db:create spec:api"
export DB=mysql

cd ${DIR}/../cloud_controller_ng
bundle install --no-deployment

language=${language:-csharp}

# Remove existing api dir
rm -rf ${DIR}/../cloud_controller_ng/doc/api/
mv -f ${DIR}/../cloud_controller_ng/spec/api/documentation/templates/rspec_api_documentation/html_example.mustache ${DIR}/html_example.mustache.bk
cp ${DIR}/html_example.mustache ${DIR}/../cloud_controller_ng/spec/api/documentation/templates/rspec_api_documentation/

bundle exec rake ${TASKS}

mv -f ${DIR}/html_example.mustache.bk ${DIR}/../cloud_controller_ng/spec/api/documentation/templates/rspec_api_documentation/html_example.mustache

# Delete existing auto-generated C# classes
rm -rf ${DIR}/../Generated/**
rm -rf ${DIR}/../tests/**

# Use codegen to generate C# classes
export BUNDLE_GEMFILE=${DIR}/../cf-sdk-builder/Gemfile
bundle install
ruby ${DIR}/../cf-sdk-builder/bin/codegen --in ${DIR}/../cloud_controller_ng/doc/api/ --out ${DIR}/../Generated/ --language ${language} --service cloudfoundry --versions v2

# Generate test classes
ruby ${DIR}/../cf-sdk-builder/bin/codegen --in ${DIR}/../cloud_controller_ng/doc/api/ --out ${DIR}/../tests/ --language ${language} --service cloudfoundry --versions v2 -t

# V3
ruby ${DIR}/../cf-sdk-builder/bin/codegen --in ${DIR}/../cloud_controller_ng/doc/api/ --out ${DIR}/../Generated/ --language ${language} --service cloudfoundry --versions v3

# Generate test classes
ruby ${DIR}/../cf-sdk-builder/bin/codegen --in ${DIR}/../cloud_controller_ng/doc/api/ --out ${DIR}/../tests/ --language ${language} --service cloudfoundry --versions v3 -t
