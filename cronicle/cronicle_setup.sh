#!/bin/sh

cd ${SPRYKER_CRONICLE_BASE_PATH}/cronicle
node bin/build.js dist
./bin/control.sh setup
node bin/hook.js before-start
./bin/control.sh start
