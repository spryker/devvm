#!/bin/sh

cd ${SPRYKER_PROJECT_ROOT}
git clone -b $CRONICLE_BRANCH $CRONICLE_REPO cronicle
cd cronicle
yarn install
node bin/build.js dist
./bin/control.sh setup
node bin/hook.js before-start
./bin/control.sh start
