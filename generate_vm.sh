#!/bin/bash
#
#     This is a script made for titou and you guys !
# 42Home the nearest 42 campus through your bed
#
# Let's discover the Peer2Home ! (^_^?)
#
# Sweetly yours
# Sweety

VM_NAME='42Home'
VM_FOLDER="$HOME"'/VirtualBox VMs'
VM_RAM="$((1024*2))"
VM_VRAM='128'

VM_HDD_SIZE="$((1024*16))"
VM_CPUS_COUNT='2'

# Don't touch
VM_OS_TYPE='Ubuntu_64'
VM_ISO='42Home.iso'


#0. Say: Hi !
echo "$VM_NAME"' X Bistro42'
echo "Welcome $USER !"
echo 'Creating VirtualBox VM...'


#1. Create VirtualMachine inside VirtualBox with VBoxManage the CLI
VBoxManage createvm --name "$VM_NAME" --ostype "$VM_OS_TYPE" --register


#2. Configure Basic system settings (Network, graphics & memory)

# http://www.virtualbox.org/manual/ch03.html#settings-motherboard
VBoxManage modifyvm "$VM_NAME" --ioapic on                     

VBoxManage modifyvm "$VM_NAME" --memory "$VM_RAM" --vram "$VM_VRAM"
VBoxManage modifyvm "$VM_NAME" --graphicscontroller vmsvga
VBoxManage modifyvm "$VM_NAME" --nic1 nat
VBoxManage modifyvm "$VM_NAME" --natpf1 "ssh,tcp,,4222,,22"
VBoxManage modifyvm "$VM_NAME" --cpus "$VM_CPUS_COUNT"


#3. Create HDD
VBoxManage createhd --filename "${VM_FOLDER}/${VM_NAME}/${VM_NAME}_DISK.vdi" --size "$VM_HDD_SIZE"  --format VDI                     
VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci       
VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "${VM_FOLDER}/${VM_NAME}/${VM_NAME}_DISK.vdi"

#4. Get and attach ISO
if ! [ -e "$VM_ISO" ]
then
	echo 'Downloading xubuntu 20.10 LTS ...'
	wget 'http://ftp.free.fr/mirrors/ftp.xubuntu.com/releases/20.10/release/xubuntu-20.10-desktop-amd64.iso'
	echo 'Now launch it again, haha !'
else
VBoxManage storagectl "$VM_NAME" --name "IDE Controller" --add ide --controller PIIX4       
VBoxManage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$(pwd)/$VM_ISO"
VBoxManage modifyvm "$VM_NAME" --boot1 dvd --boot2 disk --boot3 none --boot4 none 

# Insert Face B or Disk 2 to finish the install (^_^?)
# VboxManage startvm "$VM_NAME"
# Je me demande vraiment à quoi sert cette commande
fi
