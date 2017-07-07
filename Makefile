PREFIX ?= /usr/local

# Docker files
SRC_DOCKER_COMPOSE_FILE = docker-compose.yml
SERVICE_NAME = lnls-httpd
DOCKER_FILES_DEST = ${PREFIX}/etc/${SERVICE_NAME}

# Service files
SRC_SERVICE_FILE = ${SERVICE_NAME}.service
SERVICE_FILE_DEST = /etc/systemd/system

# HTML placement folder
HTTD_HTML_FOLDER = /home/opr24/docker-storage/lnls-httpd

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
	mkdir -p ${HTTD_HTML_FOLDER}
	cp public_html/* ${HTTD_HTML_FOLDER}
	sed -i "s;http://10.0.4.69;https://10.0.6.49;g" public_html/index.html
