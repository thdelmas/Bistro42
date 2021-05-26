#!/bin/bash

extract () {
	USAGE="usage: $0 archive"
	if ! [ "$1" ]
	then
		echo "$USAGE"	
	else
		echo $1
	fi
	EXTENSION="$(echo "$1" | rev | cut -d'.' -f1 | rev)"
	echo $EXTENSION
	TARGET_DIR="$(echo "$1" | rev | sed 's/^.*\.//g' | rev)"
	echo $TARGET_DIR
	case  $EXTENSION in
		zip)
			unzip -d "$TARGET_DIR" "$1"
			;;
		gz)
			gunzip "$1"
			;;
		tar)
			tar -xvf "$1"
			;;
		xz)
			tar -xvzf "$1"
			;;
		7z)
			echo '7z not yet supported, feel free to contribute'
			;;
		*)
			echo "Unkown file format"
			;;
	esac
}
