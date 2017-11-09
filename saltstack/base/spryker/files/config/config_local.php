<?php
/**
 * !!! This file is maintained by salt. Do not modify this file, as the changes will be overwritten!
 */
use Spryker\Shared\Session\SessionConstants;
use Spryker\Shared\Storage\StorageConstants;
use Spryker\Shared\Setup\SetupConstants;

/** Session and KV storage */
$config[StorageConstants::STORAGE_REDIS_PROTOCOL] = 'tcp';
$config[StorageConstants::STORAGE_REDIS_HOST] = '{{ settings.host.redis }}';
$config[StorageConstants::STORAGE_REDIS_PORT] = '{{ settings.environments[environment].redis.port }}';
$config[StorageConstants::STORAGE_REDIS_PASSWORD] = '';
$config[StorageConstants::STORAGE_REDIS_DATABASE] = 0;

$config[SessionConstants::YVES_SESSION_REDIS_PROTOCOL] = 'tcp';
$config[SessionConstants::YVES_SESSION_REDIS_HOST] = '{{ settings.host.redis }}';
$config[SessionConstants::YVES_SESSION_REDIS_PORT] = '{{ settings.environments[environment].redis.port }}';
$config[SessionConstants::YVES_SESSION_REDIS_DATABASE] = 1;

$config[SessionConstants::ZED_SESSION_REDIS_PROTOCOL] = 'tcp';
$config[SessionConstants::ZED_SESSION_REDIS_HOST] = '{{ settings.host.redis }}';
$config[SessionConstants::ZED_SESSION_REDIS_PORT] = '{{ settings.environments[environment].redis.port }}';
$config[SessionConstants::ZED_SESSION_REDIS_DATABASE] = 2;

/** Jenkins */
$config[SetupConstants::JENKINS_BASE_URL] = 'http://{{ settings.hosts.job|first }}:{{ settings.environments[environment].jenkins.port }}/';
$config[SetupConstants::JENKINS_DIRECTORY] = '/data/shop/{{ environment }}/shared/data/common/jenkins';
