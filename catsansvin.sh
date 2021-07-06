#!/bin/bash


# Check Dump

if ! [ "$(hostname | grep '42.fr')" ]
then
	printf 'This Script is made to work with the 42 infra only, this won'"'"'t do the job on your laptop' >&2
	exit 1
fi


# Check USER

if [ "$USER" ]
then
	echo "Welcome $USER !"
else
	printf '$USER not set\nAbort..\n' >&2
	exit 1
fi


# Check Sgoinfre

SGOINFRE_PERSO='/sgoinfre/goinfre/Perso/'"$USER"
if ! [ -d "$SGOINFRE_PERSO" ]
then
	printf "$SGOINFRE_PERSO doesn't exist\n" >&2
	mkdir -pv "$SGOINFRE_PERSO"
	chmod -R 700 "$SGOINFRE_PERSO"
fi


# Check OVA File

OVF_FILE='/sgoinfre/goinfre/ISO/xubuntu_20.04.1_LTS.ovf'
IMAGE_URL='https://sourceforge.net/projects/linuxvmimages/files/VirtualBox/X/Xubuntu_20.04.1_VB.zip/download'
if ! [ -e "$OVA_FILE" ]
then
	printf "OVA File not present, downloading\n" >&2
	curl -L --progress-bar "$IMAGE_URL" > '/tmp/xubuntu.zip'
	cd '/tmp'
	unzip 'xubuntu.zip'
	mv xubuntu.ovf "$OVF_FILE"
fi
