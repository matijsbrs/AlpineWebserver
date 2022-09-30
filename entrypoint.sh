#! /bin/sh


groupmod --gid $GID lighttpd
usermod --uid $UID lighttpd

mkdir -p /var/www/html
mkdir -p /var/run/php
mkdir -p /var/lib/lighttpd/cache/compress
mkdir -p /var/log/lighttpd
touch /var/log/lighttpd/access.log /var/log/lighttpd/error.log

cat /app/deploy.env | grep = > /var/www/html/deploy.txt
cp -r /var/www/assets /var/www/html/

# chown -R  $PUID:$PGID /var/run/php /var/log/lighttpd /var/lib/lighttpd
chown -R lighttpd:lighttpd /var/www /var/run/php /var/log/lighttpd /var/lib/lighttpd
chmod -R 755 /var/log/lighttpd




# exec 3>&1
# exec ash

exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
