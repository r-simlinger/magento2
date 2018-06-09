FROM sdafj123/php-fpm-7.1

# Install system apps
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -q -y install default-mysql-server default-mysql-client unzip

# Fix permissions
WORKDIR /www

# Install magento via zip from github
COPY www.conf /etc/nginx/conf.d/www.conf
COPY install_magento.sh /root/install_magento.sh
RUN /bin/bash -c "source /root/install_magento.sh"

CMD start.sh