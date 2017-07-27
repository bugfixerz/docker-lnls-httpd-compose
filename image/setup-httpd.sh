#!/bin/bash

PHPLDAPADMIN_VERSION=1.2.3
PHPLDAPADMIN_LINK=https://downloads.sourceforge.net/project/phpldapadmin/phpldapadmin-php5/${PHPLDAPADMIN_VERSION}/phpldapadmin-${PHPLDAPADMIN_VERSION}.zip

HTTPD_DIR=/var/www/html

wget -P ${PHPLDAPADMIN} ${PHPLDAPADMIN_LINK}
unzip ${PHPLDAPADMIN}/phpldapadmin-${PHPLDAPADMIN_VERSION}.zip -d ${HTTPD_DIR}/
patch -p1 -d ${HTTPD_DIR}/phpldapadmin-${PHPLDAPADMIN_VERSION} < ${PHPLDAPADMIN}/php5.5.patch
sed -i "s/password_hash/password_hash_custom/g" ${HTTPD_DIR}/phpldapadmin-${PHPLDAPADMIN_VERSION}/lib/TemplateRender.php

cp ${PHPLDAPADMIN}/config.php ${HTTPD_DIR}/phpldapadmin-${PHPLDAPADMIN_VERSION}/config/config.php

rm -f ${PHPLDAPADMIN}/phpldapadmin-${PHPLDAPADMIN_VERSION}.zip
