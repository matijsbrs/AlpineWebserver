#! /bin/sh


groupmod --gid $GID lighttpd
usermod --uid $UID lighttpd

mkdir -p /app/bin
mkdir -p /app/resources

# chown -R  $PUID:$PGID /var/run/php /var/log/lighttpd /var/lib/lighttpd
chown -R lighttpd:lighttpd /var/www /var/run/php /var/log/lighttpd /var/lib/lighttpd
chmod -R 755 /var/log/lighttpd


cat /opt/deploy.env | grep = > /var/www/html/deploy.txt



# exec 3>&1

exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
