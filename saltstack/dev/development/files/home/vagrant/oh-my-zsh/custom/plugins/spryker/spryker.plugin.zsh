alias composer='php -d xdebug.remote_enable=0 composer.phar'
alias ci='php -d xdebug.remote_enable=0 composer.phar install'
alias cu='php -d xdebug.remote_enable=0 composer.phar update'

alias debug='XDEBUG_CONFIG="remote_host=10.10.0.1" PHP_IDE_CONFIG="serverName=zed.de.spryker.dev"'

codecept () {
    APPLICATION_ENV=development APPLICATION_STORE=DE /data/shop/development/current/vendor/bin/codecept $*
}

debug-console () {
    XDEBUG_CONFIG="remote_host=10.10.0.1" PHP_IDE_CONFIG="serverName=zed.spryker.dev" /data/shop/development/current/vendor/bin/console $*
}

console () {
    /data/shop/development/current/vendor/bin/console $*
}

# Composer aliases
alias c='composer'
alias csu='composer self-update'
alias cu='composer update'
alias cr='composer require'
alias crm='composer remove'
alias ci='composer install'
alias ccp='composer create-project'
alias cdu='composer dump-autoload'
alias cdo='composer dump-autoload --optimize-autoloader'
alias cgu='composer global update'
alias cgr='composer global require'
alias cgrm='composer global remove'
