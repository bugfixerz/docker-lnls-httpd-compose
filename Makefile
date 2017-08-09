PREFIX ?= /usr/local

# Docker files
SRC_DOCKER_COMPOSE_FILE = docker-compose.yml
SERVICE_NAME = lnls-httpd
DOCKER_FILES_DEST = ${PREFIX}/etc/${SERVICE_NAME}

# Service files
SRC_SERVICE_FILE = ${SERVICE_NAME}.service
SERVICE_FILE_DEST = /etc/systemd/system

# HTML placement folder
HTTP_HTML_FOLDER = /home/opr24/docker-storage/lnls-httpd

# phpldapadmin download link
PHPLDAPADMIN_VERSION = 1.2.3
PHPLDAPADMIN_LINK = https://downloads.sourceforge.net/project/phpldapadmin/phpldapadmin-php5/${PHPLDAPADMIN_VERSION}/phpldapadmin-${PHPLDAPADMIN_VERSION}.zip
PHPLDAPADMIN = phpldapadmin-${PHPLDAPADMIN_VERSION}

.PHONY: all install uninstall

all:

install: configure
	mkdir -p ${DOCKER_FILES_DEST}
	cp --preserve=mode ${SRC_DOCKER_COMPOSE_FILE} ${DOCKER_FILES_DEST}
	cp --preserve=mode ${SRC_SERVICE_FILE} ${SERVICE_FILE_DEST}
	systemctl daemon-reload
	systemctl stop ${SERVICE_NAME}
	systemctl start ${SERVICE_NAME}

uninstall:
	systemctl stop ${SERVICE_NAME}
	rm -f ${SERVICE_FILE_DEST}/${SRC_SERVICE_FILE}
	rm -f -R ${DOCKER_FILES_DEST}
	systemctl daemon-reload

configure:
	rm -f -r ${HTTP_HTML_FOLDER}
	mkdir -p ${HTTP_HTML_FOLDER}
	# Copies index.html
	cp public_html/index.html ${HTTP_HTML_FOLDER}
	# Copies lnls-studio products
	cp -r public_html/lnls-studio ${HTTP_HTML_FOLDER}
	sed -i "s;http://10.0.4.69;https://10.0.4.57;g" ${HTTP_HTML_FOLDER}/index.html
	# Configures phpLDAPadmin
	wget ${PHPLDAPADMIN_LINK}
	unzip ${PHPLDAPADMIN}.zip -d ${HTTP_HTML_FOLDER}
	mv ${HTTP_HTML_FOLDER}/${PHPLDAPADMIN} ${HTTP_HTML_FOLDER}/phpldapadmin
	patch -p1 -d ${HTTP_HTML_FOLDER}/phpldapadmin < public_html/phpldapadmin/php5.5.patch
	sed -i "s/password_hash/password_hash_custom/g" ${HTTP_HTML_FOLDER}/phpldapadmin/lib/TemplateRender.php
	cp public_html/phpldapadmin/config.php ${HTTP_HTML_FOLDER}/phpldapadmin/config
	rm -f ${PHPLDAPADMIN}.zip
