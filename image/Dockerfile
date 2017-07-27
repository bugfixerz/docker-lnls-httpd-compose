FROM php:apache

RUN apt-get update && apt-get install -y libldap2-dev unzip wget

# Configures image to allow phpLDAPadmin
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap && \
    docker-php-ext-install gettext
