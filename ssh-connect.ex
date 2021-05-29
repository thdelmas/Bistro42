#!/usr/bin/expect -f
#  ./ssh.exp port ip user password
#  ./ssh.exp 4222 127.0.0.1 student student

set sshport [lrange $argv 0 0]
set server [lrange $argv 1 1]
set user [lrange $argv 2 2]
set pass [lrange $argv 3 3]

spawn scp -P$sshport -pr ansible/roles/common/files/.ssh $user@$server:/home/$user/
match_max 100000
expect "password: $"
send -- "$pass\r"
send -- "\r"
interact
