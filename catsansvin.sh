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
	mkdir -pv "$SGOINFRE_PERSO/VirtualBoxVMs"
	vboxmanage setproperty machinefolder "$SGOINFRE_PERSO/VirtualBoxVMs"
	chmod -R 700 "$SGOINFRE_PERSO"
fi


# Check OVA File

OVA_FILE='/sgoinfre/goinfre/ISO/Xubuntu_20.04.1_VB_LinuxVMImages.COM.ova'
IMAGE_URL='https://sourceforge.net/projects/linuxvmimages/files/VirtualBox/X/Xubuntu_20.04.1_VB.zip/download'
if ! [ -e "$OVA_FILE" ]
then
	printf "OVA File not present, downloading\n" >&2
	curl -L --progress-bar "$IMAGE_URL" > '/tmp/xubuntu.zip'
	cd '/tmp'
	unzip 'xubuntu.zip'
	mv Xubuntu_20.04.1_VB_LinuxVMImages.COM.ova "$OVA_FILE"
	cd -
fi


# Import VM

TC_RED="\033[31m"
TC_RESET="\033[0;0m"

VM_NAME="42OS"
VM_RAM="$((1024*2))"
VM_VRAM='128'
VM_CPUS_COUNT='2'

# Ensure VM exist or create it
if ! [ "$(vboxmanage list vms | grep "$VM_NAME")" ]
then
	# Import downloaded file & accept VBox licence
	printf "${TC_YELLOW}Import ova... ${TC_RESET}\n"
	if ! vboxmanage import "$OVA_FILE" --vsys 0 --eula accept --vmname "$VM_NAME"
	then
		printf "${TC_RED}Failed to import the VM${TC_RESET}\n"
		printf "${TC_RED}Check free space on disk${TC_RESET}\n"
		exit 1
	fi
	# Configure Basic system settings (Network, graphics & memory)
	VBoxManage modifyvm "$VM_NAME" --ioapic on
	VBoxManage modifyvm "$VM_NAME" --memory "$VM_RAM" --vram "$VM_VRAM"
	VBoxManage modifyvm "$VM_NAME" --graphicscontroller vmsvga
	VBoxManage modifyvm "$VM_NAME" --nic1 nat
	VBoxManage modifyvm "$VM_NAME" --natpf1 "ssh,tcp,,4222,,22"
	VBoxManage modifyvm "$VM_NAME" --cpus "$VM_CPUS_COUNT"
	old_description="$(VBoxManage showvminfo "$VM_NAME" --details | sed -n '/Description:/,/Guest:/p' | grep -Ev "(Description:|Guest:)" | head -n1)"
	VBoxManage modifyvm "42OS" --description "$(printf "\t42 - ${old_description}\n\nBecause of the current crisis, you are allowed to organize remote defenses on Linux VM, on
	allowed projects only, in order to progress into your curriculum.\n")"
else
	printf "${TC_RED}There is already a VM with the name: ${VM_NAME}${TC_RESET}\n"
fi

# Ensure VM is up or start it
if ! [ "$(vboxmanage list runningvms | grep "$VM_NAME")" ]
then
	VboxManage startvm "$VM_NAME"
else
	printf "${TC_RED}VM with the name: ${VM_NAME} is already running${TC_RESET}\n"
fi


# Copy SSH-Key

./ssh-connect.ex 4222 127.0.0.1 'xubuntu' 'xubuntu'


# Configure VM

git clone 'https://github.com/thdelmas/42Cursus-playbooks'
cd 42Cursus-playbooks
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt


ansible -m ping all
if [ "$1" ]
then
	;#ansible-playbook site.yml --tags="$1"
else
	;#ansible-playbook site.yml
fi
cd -
