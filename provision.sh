#!/bin/bash
      
PUPPET_MODULES_DIR=/etc/puppet/modules
PUPPET_MODULE_NPM_PROVIDER_DIR=${PUPPET_MODULES_DIR}/npm-provider/lib/puppet/provider/package
PUPPET_MODULE_NPM_PROVIDER_URL=https://raw.github.com/puppetlabs/puppetlabs-nodejs/master/lib/puppet/provider/package/npm.rb

mkdir -p ${PUPPET_MODULES_DIR}
puppet module install -f puppetlabs/stdlib
puppet module install -f puppetlabs/apt

echo "Preparing to install npm provider..."
mkdir -p ${PUPPET_MODULE_NPM_PROVIDER_DIR}

echo -n "Downloading npm provider... "
wget -q -P ${PUPPET_MODULE_NPM_PROVIDER_DIR} ${PUPPET_MODULE_NPM_PROVIDER_URL}

STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo "done"
else
  echo "error" >&2
  exit $STATUS
fi
