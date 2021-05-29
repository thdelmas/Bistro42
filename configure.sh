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

if [ "$(ls ~/.ssh/*.pub | grep "id_rsa_$USER")" ]
then
	sed "s/id_rsa_student/id_rsa_$USER/g" ./ansible/ansible.cfg > ./ansible/new_ansible.cfg
	mv ./ansible/new_ansible.cfg ./ansible/ansible.cfg
fi

mkdir -pv ansible/roles/common/files/.ssh
for i in ~/.ssh/*.pub
do
	rm -vf ansible/roles/common/files/authorized_keys
	cat "$i" >> ansible/roles/common/files/.ssh/authorized_keys
	chmod +rw ansible/roles/common/files/.ssh/authorized_keys
done

./ssh-connect.ex 4222 127.0.0.1 "$NAME_FORMATED" "$NAME_FORMATED"

cd ansible
ansible -m ping all
ansible-playbook site.yml
#rm -vf roles/common/files/.ssh/authorized_keys
cd ..
