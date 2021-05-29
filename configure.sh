#!/bin/bash

if ! [ "$1" ]
then
	echo "Missing arg"
	exit 1
fi

BISTROS_VENV=".venv"

echo "Procedding conf for ansible"

NAME_FORMATED="$(echo "$1" | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]' | sed 's/[0-9]*//g')"

if ! [ -e "$BISTROS_VENV" ]
then
	python3 -m venv "$BISTROS_VENV"
fi

source "$BISTROS_VENV"/bin/activate
pip install -r requirements.txt
sed "s/student/$NAME_FORMATED/g" ./ansible/ansible.cfg > ./ansible/new_ansible.cfg
mv ./ansible/new_ansible.cfg ./ansible/ansible.cfg
sed "s/id_rsa_student/id_rsa_$USER/g" ./ansible/ansible.cfg > ./ansible/new_ansible.cfg
mv ./ansible/new_ansible.cfg ./ansible/ansible.cfg

mkdir -pv ansible/roles/common/files/.ssh
for i in ~/.ssh/*.pub
do
	cat "$i" >> ansible/roles/common/files/.ssh/authorized_keys
done

sleep 3
./ssh-connect.ex 4222 127.0.0.1 "$NAME_FORMATED" "$NAME_FORMATED"
cd ansible
ansible -m ping all
ansible-playbook site.yml
