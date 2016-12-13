#!/bin/bash

PHP_VERSION=`php -v`
PHP_ETC_DIR=/etc/php/7.0/
PHP_VERSION_NUMBER=7

if [[ $PHP_VERSION =~ "PHP 5" ]] ; then
    PHP_ETC_DIR=/etc/php5/
    PHP_VERSION_NUMBER=5
fi

XDEBUG_INI=${PHP_ETC_DIR}mods-available/xdebug.ini
PHP_CLI_DIR=${PHP_ETC_DIR}cli/conf.d/
PHP_FPM_DIR=${PHP_ETC_DIR}fpm/conf.d/

echo "Detected PHP version: ${PHP_VERSION_NUMBER}.x";

function restartFPM {
	sudo /etc/init.d/php5-fpm restart
}

function xdebugOn {
	if [ ! -f "${PHP_CLI_DIR}30-xdebug.ini" ]; then
		echo "Enabling CLI Xdebug"
		sudo ln -s $XDEBUG_INI "${PHP_CLI_DIR}30-xdebug.ini"
	else
		echo " - CLI Xdebug already enabled"
	fi

    if [ ! -f "${PHP_FPM_DIR}30-xdebug.ini" ]; then
        echo "Enabling FPM Xdebug"
		sudo ln -s $XDEBUG_INI "${PHP_FPM_DIR}30-xdebug.ini"
		restartFPM
    else
        echo " - FPM Xdebug already enabled"
    fi 
}

function xdebugOff {
    if [ -f "${PHP_CLI_DIR}30-xdebug.ini" ]; then
        echo "Disabling CLI Xdebug"
        sudo rm "${PHP_CLI_DIR}30-xdebug.ini"
    else
        echo " - CLI Xdebug is not enabled"
    fi  

    if [ -f "${PHP_FPM_DIR}30-xdebug.ini" ]; then
        echo "Disabling FPM Xdebug"
        sudo rm "${PHP_FPM_DIR}30-xdebug.ini"
		restartFPM
    else
        echo " - FPM Xdebug is not enabled"
    fi  
}

function reportStatus {
    if [ -f "${PHP_CLI_DIR}30-xdebug.ini" ]; then
        echo "CLI Xdebug is enabled"
	else
		echo "CLI Xdebug is disabled"	
    fi

    if [ -f "${PHP_FPM_DIR}30-xdebug.ini" ]; then
        echo "FPM Xdebug is enabled"
    else
        echo "FPM Xdebug is disabled"   
    fi
}

case $1 in
    --on) 
		xdebugOn
	;;
    --off) 
		xdebugOff
	;;

    *) 
		reportStatus
		echo "Use --on or --off"
	;;
esac;
