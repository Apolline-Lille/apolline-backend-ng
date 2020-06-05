#!/bin/bash

DOCKER="docker-compose"

usage()
{
	echo "$0 [up/down] [variant=default,jupyter]"
}

if [ "$#" -eq 0 ]
then
	echo "No arguments supplied"
	usage
	exit 0
elif [ "$#" -eq 2 ]
then
	VARIANT="$2"
else
	VARIANT="default"
fi

$DOCKER -f docker-compose-$VARIANT.yml $1
