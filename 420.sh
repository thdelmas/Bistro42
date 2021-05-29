#!/bin/bash
#
#     This is a script made for titou and you guys !
# 42Home the nearest 42 campus through your bed
#
# Let's discover the Peer2Home ! (^_^?)
#
# Sweetly yours
# Sweety


# Import useful functions
source linuxvmimages_downloader.sh
source linuxvmimages_import.sh


# Termcaps Colors
TC_RED="\033[31m"
TC_GREEN="\033[32m"
TC_YELLOW="\033[33m"
TC_BLUE="\033[34m"
TC_RESET="\033[0;0m"

# Il a pas dit bonjour, 
printf "${TC_GREEN}\t🍻 Bistro42 🍻\n${TC_BLUE}Welcome ${USER}${TC_RESET}\n"

# Download your linux flavour
linuxvmimages_downloader

# Insert Face B or Disk 2 to finish the install (^_^?)
linuxvmimages_import

if [ "$SELECTION" ]
then
	./configure.sh "$SELECTION"
fi
