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
source extract_any_archive.sh


# Termcaps Colors
TC_GREEN="\033[32m"
TC_YELLOW="\033[33m"
TC_BLUE="\033[34m"
TC_RESET="\033[0;0m"

# General Settings
VM_NAME="42OS"
VM_RAM="$((1024*2))"
VM_VRAM='128'
VM_CPUS_COUNT='2'


# Start
printf "${TC_BLUE}\t42OS\nWelcome ${USER}${TC_RESET}\n"
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


mkdir build
cd build
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
	fi
fi
extract "$TARGET_FILE"

# Import downloaded file & accept VBox licence
printf "${TC_YELLOW}Import ova... ${TC_RESET}\n"
vboxmanage import "$(find '.' -name '*.ova')" --vsys 0 --eula accept --vmname "$VM_NAME"

# Configure Basic system settings (Network, graphics & memory)
VBoxManage modifyvm "$VM_NAME" --ioapic on

VBoxManage modifyvm "$VM_NAME" --memory "$VM_RAM" --vram "$VM_VRAM"
VBoxManage modifyvm "$VM_NAME" --graphicscontroller vmsvga
VBoxManage modifyvm "$VM_NAME" --nic1 nat
VBoxManage modifyvm "$VM_NAME" --natpf1 "ssh,tcp,,4222,,22"
VBoxManage modifyvm "$VM_NAME" --cpus "$VM_CPUS_COUNT"
cd ..

# Insert Face B or Disk 2 to finish the install (^_^?)
VboxManage startvm "$VM_NAME"
# Je me demande vraiment à quoi sert cette commande

./configure_ansible.sh "$SELECTION"

#rm -rf 'build'
