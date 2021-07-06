#!/usr/bin/expect -f
#  ./ssh.exp port ip user password
#  ./ssh.exp 4222 127.0.0.1 student student

set sshport [lrange $argv 0 0]
set server [lrange $argv 1 1]
set user [lrange $argv 2 2]
set pass [lrange $argv 3 3]

set timeout -1
match_max 10000
spawn scp -P$sshport -pr "$env(HOME)/.ssh/" "$user@$server:/home/$user/"
expect "s password: $"
send -- "$pass\r"
interact
