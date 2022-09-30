#! /bin/sh

set -e

[[ "$DEBUG" == "true" ]] && set -x

# addgroup -g $PGID www-data
#adduser -u $PUID -G www-data -D -H www-data
groupmod --gid $GID lighttpd
usermod --uid $UID lighttpd

mkdir -p /var/www/html
mkdir -p /var/run/php
mkdir -p /var/lib/lighttpd/cache/compress
mkdir -p /var/log/lighttpd
touch /var/log/lighttpd/access.log /var/log/lighttpd/error.log

# chown -R  $PUID:$PGID /var/run/php /var/log/lighttpd /var/lib/lighttpd
chown -R lighttpd:lighttpd /var/www /var/run/php /var/log/lighttpd /var/lib/lighttpd
chmod -R 755 /var/log/lighttpd


cat /opt/deploy.env | grep = > /var/www/html/deploy.txt



# exec 3>&1

exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
