FROM alpine:latest
LABEL maintainer="Matijs Behrens" \
      version="1.0.0"

# Add edge/community  repos for usermod (shadow) 
# RUN echo http://dl-2.alpinelinux.org/alpine/v3.16/community/ >> /etc/apk/repositories

# Install packages: shadow,curl and cmatrix (as demo) you can add more
# The cache is removed
RUN apk update && \
    apk add --no-cache \
    shadow \
    cmatrix \
    curl && \
    rm -rf /var/cache/apk/*

# add a default docker user change the group and name if you like. (also do the *.env files)
RUN adduser docker -D -H docker

# Create base files
RUN mkdir -p /app/bin
RUN mkdir -p /app/resources

# Copy files. At this point it is all default except
COPY deploy.env /app/
COPY entrypoint.sh /app/

# use the argument to force skip cache during builds
ARG COPY_CONFIG=true
COPY config/*.conf /etc/app/
COPY app/* /app/bin

# make sure it can be executed
RUN chmod a+x /app/entrypoint.sh

# Check every minute if the webserver responds within 1 second and update
# container health status accordingly.
#HEALTHCHECK --interval=1m --timeout=1s \
#  CMD curl -f http://localhost/ || exit 1

# Check every minute if a process is acive
HEALTHCHECK --interval=1m --timeout=1s \
  CMD ps | grep cmatrix -c  || echo 1

# Uncomment to Expose a port. change the port number accordingly
# EXPOSE 80 

# Make the resources path a volume
VOLUME /app/resources

ENTRYPOINT ["/app/entrypoint.sh"]