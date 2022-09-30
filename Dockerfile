FROM alpine:latest
LABEL maintainer="Matijs Behrens" \
      version="1.0.0"

# Add edge/community  repos for usermod (shadow)
RUN echo http://dl-2.alpinelinux.org/alpine/v3.16/community/ >> /etc/apk/repositories

# Install packages
RUN apk update && \
    apk add --no-cache \
    shadow \
    lighttpd \
    php8 php8-cgi php8-json php8-session php8-pdo php8-pdo_mysql php8-ctype \
    curl && \
    rm -rf /var/cache/apk/*


# Copy lighttpd config files. At this point it is all default except
# including a custom ssl.conf in lighttpd.conf.
COPY deploy.env /opt/
COPY entrypoint.sh /opt/
ARG COPY_CONFIG=true
COPY config/*.conf /etc/lighttpd/
#COPY config/lighttpd/conf-enabled/*.conf /etc/lighttpd/conf-enabled/ 

# make sure it can be executed
RUN chmod a+x /opt/entrypoint.sh

# Check every minute if lighttpd responds within 1 second and update
# container health status accordingly.
HEALTHCHECK --interval=1m --timeout=1s \
  CMD curl -f http://localhost/ || exit 1

# Expose http port
# This webserver will only run behind Traefik
EXPOSE 80 

# Make configuration path and webroot a volume
VOLUME /etc/lighttpd/
VOLUME /var/www/html

#ENTRYPOINT ["/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
ENTRYPOINT ["/opt/entrypoint.sh"]