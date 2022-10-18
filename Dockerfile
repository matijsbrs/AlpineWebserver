FROM alpine:latest
LABEL maintainer="Matijs Behrens" \
      version="1.1.2"

# Add edge/community  repos for usermod (shadow) 
# RUN echo http://dl-2.alpinelinux.org/alpine/v3.16/community/ >> /etc/apk/repositories

# Install packages
RUN apk update && \
    apk add --no-cache \
    shadow \
    lighttpd \
    php8 php8-cgi php8-json php8-session php8-pdo php8-pdo_mysql php8-ctype \
    curl && \
    rm -rf /var/cache/apk/*

# add a default docker user change the group and name if you like. (also do the *.env files)
# RUN adduser docker -D -H docker

# Create base files
RUN mkdir -p /app/bin
RUN mkdir -p /var/www/assets/js

# Download Bootstrap
ADD https://github.com/twbs/bootstrap/releases/download/v5.2.1/bootstrap-5.2.1-dist.zip /var/www/assets/
RUN unzip /var/www/assets/bootstrap-5.2.1-dist.zip -d /var/www/assets/ && mv /var/www/assets/bootstrap-5.2.1-dist /var/www/assets/bootstrap
RUN rm -f /var/www/assets/bootstrap-5.2.1-dist.zip

# Download Bootstrap icons
ADD https://github.com/twbs/icons/releases/download/v1.9.1/bootstrap-icons-1.9.1.zip /var/www/assets/ 
RUN unzip /var/www/assets/bootstrap-icons-1.9.1.zip -d /var/www/assets/ && mv /var/www/assets/bootstrap-icons-1.9.1 /var/www/assets/icons
RUN rm -f /var/www/assets/bootstrap-icons-1.9.1.zip

ADD https://code.jquery.com/jquery-3.6.1.min.js /var/www/assets/js/


# Copy files. At this point it is all default except
COPY deploy.env /app/
COPY entrypoint.sh /app/

# use the argument to force skip cache during builds
ARG COPY_CONFIG=true
COPY config/*.conf /etc/lighttpd/

# make sure it can be executed
RUN chmod a+x /app/entrypoint.sh

# Check every minute if the webserver responds within 1 second and update
# container health status accordingly.
# @021022^MB check deploy.txt This file is always available. 
HEALTHCHECK --interval=1m --timeout=1s \
 CMD curl -f http://localhost/deploy.txt || exit 1


# Uncomment to Expose a port. change the port number accordingly
EXPOSE 80 

# Make the resources path a volume
VOLUME /var/www/html

ENTRYPOINT ["/app/entrypoint.sh"]
