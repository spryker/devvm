# Shortcuts for Spryker binaries
codecept () {
    APPLICATION_ENV=development APPLICATION_STORE=SO /data/shop/development/current/vendor/bin/codecept $*
}

console () {
    /data/shop/development/current/vendor/bin/console $*
}

debug-console () {
    XDEBUG_CONFIG="remote_host=10.10.0.1" PHP_IDE_CONFIG="serverName=zed.so.akona.local" /data/shop/development/current/vendor/bin/console $*
}

install () {
    APPLICATION_ENV=development /data/shop/development/current/vendor/bin/install $*
}

# XDebug
alias debug='XDEBUG_CONFIG="remote_host=10.10.0.1" PHP_IDE_CONFIG="serverName=zed.so.akona.local"'

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
