#! /bin/sh

# Adapt the USER to the given GID and UID to integrate with the host computer.
groupmod --gid $GID $USER
usermod --uid $UID $USER

# An example operation. 
cp /app/deploy.env /app/resources

# change the user rights to a folder
chown -R $USER:$USER /app/resources
chmod -R 755 /app/resources

# execute the program as given user
# this is not explicitly necessary. 
exec su $USER -c 'cmatrix -s'
