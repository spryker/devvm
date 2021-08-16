#!/bin/sh

export ENV CRONICLE_REPO="https://github.com/spryker-sdk/Cronicle.git"
export ENV CRONICLE_BRANCH="master"
export SPRYKER_PROJECT_ROOT=/data/shop/development/current
export SPRYKER_ENABLED_SCHEDULERS="{\"cronicle\":{\"base_url\":\"http:\\/\\/localhost:3012\",\"api_key\":\"secure-string\"}}"
export SPRYKER_ENABLED_SCHEDULER_STORES="[\"DE\",\"AT\",\"US\"]"
export SPRYKER_STORE_SPECIFIC="{\"DE\":{\"APPLICATION_STORE\":\"DE\",\"SPRYKER_SEARCH_NAMESPACE\":\"de_search\",\"SPRYKER_KEY_VALUE_STORE_NAMESPACE\":1,\"SPRYKER_BROKER_NAMESPACE\":\"DE_development_zed\",\"SPRYKER_SESSION_BE_NAMESPACE\":2},\"AT\":{\"APPLICATION_STORE\":\"AT\",\"SPRYKER_SEARCH_NAMESPACE\":\"at_search\",\"SPRYKER_KEY_VALUE_STORE_NAMESPACE\":1,\"SPRYKER_BROKER_NAMESPACE\":\"AT_development_zed\",\"SPRYKER_SESSION_BE_NAMESPACE\":2},\"US\":{\"APPLICATION_STORE\":\"US\",\"SPRYKER_SEARCH_NAMESPACE\":\"us_search\",\"SPRYKER_KEY_VALUE_STORE_NAMESPACE\":1,\"SPRYKER_BROKER_NAMESPACE\":\"DE_development_zed\",\"SPRYKER_SESSION_BE_NAMESPACE\":2}}"
export SPRYKER_CURRENT_SCHEDULER="cronicle"
export SPRYKER_SCHEDULER_API_KEY="secure-string"
export SPRYKER_SCHEDULER_ADMIN_USERNAME="spryker"
export SPRYKER_SCHEDULER_ADMIN_PASSWORD="secret"
export SPRYKER_SCHEDULER_ADMIN_EMAIL="admin@spryker.local"
