#!/usr/bin/expect
set timeout 30
set ip_local [lindex $argv 0]
set password [lindex $argv 1]

spawn ssh root@$ip_local
expect { 
    "yes/no" {send "yes\r";exp_continue}    #返回结果如果包含yes/no 自动填写yes
    "password:" {send "$password\r"}          # 自动填写密码
}

expect {
    "root@vultr:~#" {send "wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssr.sh && chmod +x ssr.sh && bash ssr.sh\r";}
}
# send "sudo -s\r"
# send "cd /usr/local/\r"
interact