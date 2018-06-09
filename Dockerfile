FROM sdafj123/php-fpm-7.1

WORKDIR /www
# Running install.sh for $1 using $2 as server name

# Define composer auth for magento
RUN mkdir -p /root/.composer
COPY composer_auth.json /root/.composer/auth.json

# Copy magento via composer (needs an empty /www folder!)
RUN composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /www

# Define composer auth for magento
RUN mkdir -p /www/var/composer_home
COPY composer_auth.json /www/var/composer_home/auth.json

# Setting filesystem permissions
RUN find var generated vendor pub/static pub/media app/etc -type f -exec chmod u+w {} \;
RUN find var vendor generated pub/static pub/media app/etc -type d -exec chmod u+w {} \;
RUN chmod u+x bin/magento

# Install magento
RUN php bin/magento sampledata:deploy
RUN php bin/magento setup:install --admin-firstname="Ad" --admin-lastname="Minator" --admin-email="adminator@adminator.ro" --admin-user="Adminator" --admin-password="sdr117781" --base-url="http://$2:6090/" --backend-frontname="admin" --db-host="database" --db-name="secu" --db-user="secu" --db-password="secu"

RUN php bin/magento admin:user:unlock Adminator

# Setting filesystem permissions
RUN chown -R www-data /www
RUN chgrp -R www-data /www

RUN php bin/magento setup:static-content:deploy -f
RUN php bin/magento cache:flush
RUN php bin/magento indexer:reindex
