#! /bin/bash
mage=2.2.4
url=http://173.212.254.177:6090/
host=localhost
#host='%'


## Init DB
/etc/init.d/mysql restart

commands="CREATE DATABASE \`secu\`;CREATE USER 'secu'@'${host}' IDENTIFIED BY 'secu';GRANT USAGE ON *.* TO 'secu'@'${host}' IDENTIFIED BY 'secu';GRANT ALL privileges ON \`secu\`.*
TO 'secu'@'${host}';FLUSH PRIVILEGES;"

echo "${commands}" | mysql


## Install magento
cd /www

wget -q https://github.com/magento/magento2/archive/${mage}.zip
unzip -q ${mage}.zip -d .
rm ${mage}.zip
cd /www
mv magento2-${mage}/* magento2-${mage}/.[^.]* . && rmdir magento2-${mage}/

wget -q https://github.com/magento/magento2-sample-data/archive/${mage}.zip
unzip -q ${mage}.zip
php -f /www/magento2-sample-data-${mage}/dev/tools/build-sample-data.php -- --ce-source="/www"
rm ${mage}.zip

composer install --no-dev

find var generated vendor pub/static pub/media app/etc -type f -exec chmod u+w {} \;
find var vendor generated pub/static pub/media app/etc -type d -exec chmod u+w {} \;
chmod u+x bin/magento

php bin/magento setup:install \
  --admin-firstname=secu \
  --admin-lastname=x \
  --admin-email=secu@example.com \
  --admin-user=secu \
  --admin-password=secu \
  --base-url=${url} \
  --backend-frontname=admin \
  --db-host=localhost \
  --db-name=secu \
  --db-user=secu \
  --db-password=secu \
  --language=de_DE \
  --currency=EUR \
  --timezone=Europe/Berlin
  
## Setting file permissions
chown -R www-data /www
chgrp -R www-data /www

## php bin/magento setup:static-content:deploy -f
## php bin/magento cache:flush
## php bin/magento indexer:reindex