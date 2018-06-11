FROM sdafj123/php-fpm-7.1

# Define environment variables
ENV SHOP_VERSION 2.2.4
ENV VIRTUAL_HOST magento2.runtest.de
ENV LETSENCRYPT_HOST magento2.runtest.de
ENV LETSENCRYPT_EMAIL foo@simlinger.eu

# Install system apps
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update && apt-get -qq -y install default-mysql-server default-mysql-client unzip

# Fix permissions
WORKDIR /www

# Install magento via zip from github
COPY www.conf /etc/nginx/conf.d/www.conf
COPY install_magento.sh /root/install_magento.sh
RUN chmod +x /root/install_magento.sh
RUN /root/install_magento.sh $VIRTUAL_HOST $SHOP_VERSION

ADD start.sh /root/start.sh
RUN chmod +x /root/start.sh
ENTRYPOINT /root/start.sh

EXPOSE 3306
