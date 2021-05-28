#!/bin/bash

if ! [ "$1" ]
then
	echo "Missing arg"
	exit 1
fi

echo "Procedding conf for ansible"

NAME_FORMATED="$(echo "$1" | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]' | sed 's/[0-9]*//g')"

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
sed "s/student/$NAME_FORMATED/g" ./ansible/ansible.cfg > ./ansible/new_ansible.cfg
mv ./ansible/new_ansible.cfg ./ansible/ansible.cfg
./ssh-connect.ex 4222 127.0.0.1 "$NAME_FORMATED" "$NAME_FORMATED"
cd ansible
ansible -m ping all
