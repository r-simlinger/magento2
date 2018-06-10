FROM sdafj123/php-fpm-7.1

# Define environment variables
ENV VIRTUAL_HOST magento2.runtest.de
ENV SHOP_VERSION 2.2.4

# Install system apps
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update
RUN apt-get -q -y install default-mysql-server default-mysql-client unzip

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
