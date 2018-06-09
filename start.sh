#!/bin/bash
/etc/init.d/mysql start
/etc/init.d/php7.1-fpm start
/etc/init.d/nginx start
while true; do sleep 1d; done