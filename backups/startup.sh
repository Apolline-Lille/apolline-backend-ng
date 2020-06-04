#!/bin/bash

# Configure image
echo Configuring image
apk update
apk add openssh
apk add rsync

# Check for SSH host keys
echo Configuring ssh
if [ -f "/root/.ssh/id_rsa" ]; then
	echo Container already has a keypair - skipping
else
	echo Container does not have a keypair - generating
	ssh-keygen -t rsa -f /home/root/.ssh/id_rsa -q -P ""
fi

# Start cron job
echo Adding crontab entries

echo Crontab rules:
crontab -l

echo Starting backup service as `whoami`
crond -f -l 8
