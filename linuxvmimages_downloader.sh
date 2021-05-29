#!/bin/bash

source extract_any_archive.sh

linuxvmimages_downloader() {
	TC_RED="\033[31m"
	TC_BLUE="\033[34m"
	TC_GREEN="\033[32m"
	TC_YELLOW="\033[33m"
	TC_RESET="\033[0;0m"
	BISTROS_BUILD_DIR=".build"

	printf "${TC_YELLOW}Please choose your base distribution${TC_RESET}\n"

	# Prevent unwanted space spliting
	OLD_IFS="$IFS"
	IFS='
	'

	# Fetch linuxvmimages.com
	CURL_RESULT="$(curl --progress-bar https://www.linuxvmimages.com/images/ 2>/dev/null | grep h4 | sed -E 's/<h4>|<\/h4>//g')"
	AVAILABLE_OS=''

	for i in $CURL_RESULT
	do
		SHORTNAME="$(echo $i | cut -d'>' -f2 | cut -d'<' -f1)"
		if [ "$SHORTNAME" ]
		then
			AVAILABLE_OS="$AVAILABLE_OS
			$SHORTNAME"
		fi
	done

	# Select Base OS
	select SELECTION in $(echo "$AVAILABLE_OS" | sort)
	do
		printf "Your selection: ${TC_GREEN}$SELECTION${TC_RESET}\n"
		break
	done

	# Reset IFS
	IFS="$OLD_IFS"

	TARGET_OS_URL="$(echo "$CURL_RESULT" |
		grep ">$SELECTION<" |
		cut -d'"' -f2)"

	IMAGE_URL="$(curl "$TARGET_OS_URL" | 
		grep 'download' |
		grep 'http' |
		tr ' ' "\n" |
		grep 'href' |
		cut -d'"' -f2 |
		head -n1)"

	mkdir "$BISTROS_BUILD_DIR"
	cd "$BISTROS_BUILD_DIR"
	printf "${TC_BLUE}Downloading OS image\n${TC_YELLOW}${IMAGE_URL}${TC_RESET}\n" >&2

	TARGET_FILE="$(echo "$IMAGE_URL" | rev | tr '/' "\n" | rev | grep '\.' | head -n1)"
	if ! [ "$(file "$TARGET_FILE" | grep 'archive')" ]
	then
		curl  -L --progress-bar -o "$TARGET_FILE" "$IMAGE_URL"
		if ! [ "$(file "$TARGET_FILE" | grep 'archive')" ]
		then
			IMAGE_URL="$(echo $IMAGE_URL | sed 's/^.*=//g')"
			echo "$IMAGE_URL"
			TARGET_FILE="$(echo "$IMAGE_URL" | rev | tr '/' "\n" | rev | grep '\.' | head -n1)"
			curl  -L --progress-bar -o "$TARGET_FILE" "$IMAGE_URL"
			extract "$TARGET_FILE"
		fi
	fi
	cd ..
}
