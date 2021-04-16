#!/bin/bash


# Stage 1

echo 'Updating system ...'
apt update
apt upgrade -y

echo 'SSH installation ...'
apt install -y openssh-server

echo 'Basic utilities installation ...'
apt install -y curl


echo 'Run this command to connect to your VM:'
echo 'ssh -p 4222 student@127.0.0.1'

# Stage 2

while [ ! "$login" ]
do
printf "What's your login ?    "
read login
done
echo Welcome $login '!'

curl 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/42_Logo.svg/1200px-42_Logo.svg.png' > '/home/student/Pictures/bg.png'
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitorVirtual1/workspace0/last-image --set '/home/student/Pictures/bg.png'
