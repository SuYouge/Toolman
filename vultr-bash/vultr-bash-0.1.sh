#!/bin/bash

# 如果配置过程中脚本界面被关闭不知道会发生什么 ……

# 需要创建.config文件
get_key(){
config=$(cat ./.config)
API_KEY=$(sed -n 1p ./.config)
# API_KEY=${config:$(expr $(expr index $config KEY= ) + 3):37}
echo $API_KEY
# ssr_path=$(sed -n 2p ./.config)
# echo $ssr_path
}

# DCID = 39; OSID = 270; VPSPLANID=202
create_server(){
# run region 
curl https://api.vultr.com/v1/regions/list |python -mjson.tool |awk '/DCID/||/country/||/name/'|awk 'ORS=NR%3?" ":"\n"{print}'| tr '"' ' '| tr ',' ' ' # '{N;N;s/\n/\t/p}'
echo "Input the DCID"
read -p "Enter DCID > " DCID
# run os
curl https://api.vultr.com/v1/os/list | python -mjson.tool |awk '/OSID/||/name/'|awk 'ORS=NR%2?" ":"\n"{print}'|grep "Ubuntu"| tr '"' ' '| tr ',' ' '
echo "Input the OS type"
read -p "Enter OSID > " OSID
curl https://api.vultr.com/v1/plans/list?type=ssd | python -mjson.tool|awk '/VPSPLANID/||/price_per_month/'|awk 'ORS=NR%2?" ":"\n"{print}'| tr '"' ' '| tr ',' ' '
read -p "Enter VPSPLANID > " VPSPLANID
echo "Start creating server"
# create_SUBID=$(curl -H "API-Key: $API_KEY" https://api.vultr.com/v1/server/create --data "DCID=$DCID" --data "VPSPLANID=$VPSPLANID" --data "OSID=$OSID")
# 测试语句
# create_SUBID="33189406"
# server_SUBID="33189406"
# 测试语句
echo "creating $create_SUBID"
}


# 读取服务器列表并获取IP等信息
server_list() {
# 判断是否刚刚创建了服务器
if [ $create_SUBID ]; then
    echo "hase create subid"
    server_state=$(curl -H "API-Key: $API_KEY" -G --data "SUBID=$create_SUBID" https://api.vultr.com/v1/server/list)
    else
    server_state=$(curl -H "API-Key: $API_KEY" https://api.vultr.com/v1/server/list)
fi
server_SUBID=$(echo $server_state | python -mjson.tool | awk '/SUBID/' | awk -F "[\"\"]" '{print $4}')
server_PWD=$(echo $server_state | python -mjson.tool | awk '/default_password/'| awk -F "[\"\"]" '{print $4}')
server_IP=$(echo $server_state | python -mjson.tool | awk '/main_ip/'| awk -F "[\"\"]" '{print $4}')
server_OK=$(echo $server_state | python -mjson.tool | awk '/status/'| awk -F "[\"\"]" '{print $4}'| sed ':t;N;s/\n//;b t') # shit 最后一部分是把两个状态之间的换行符去掉 而不是空格！！！！
# server_SUBID=${server_state:1:20}
echo $server_SUBID
echo $server_PWD
echo $server_IP
echo $server_OK
}


# 因为差不多只用一个服务器，获得key以后，首先检查一下是否已经有服务器了
create_one(){
    # 如果已有subid并且server_OK则开始ssh并结束bash
    if [[ "$server_SUBID" && "$server_OK" == "runningactive" ]]; then
    {
        echo "there is a server already"
        # 运行ssh
        exit
    }
    fi
    # 如果一开始没有subid就进入创建服务器的阶段
    # 首先检查曾经是否创建过服务器，如果有就延时并检查server_list，检查完成后进入递归
    # 如果没有发出过创建服务器的指令，则运行创建的指令并递归
    if [ "$create_SUBID" ]; then
        echo "delaying"
        server_list
        clock_t
        create_one
    else 
        echo "execute once only"
        create_server
        create_one
    fi
}

# 主函数
main()  
{  
    get_key # 读取key
    server_list # 检查一次服务器
    # create_one # 按照检查结果选择布置ssr或开启服务器  
    # sudo apt-get install expect
    ./login_ssh.sh $server_IP $server_PWD
}  
main  

# 倒计时函数
clock_t(){
    t=300
    for((t;t>0;t--))	##for循环时间每次循环自减1
    do 
    m=$((t/60))	##总秒	数除以60的商为新的分钟
    s=$((t%60))	##总秒数对60的取余为新的秒数
    echo "$m:$s"	##输出时间
    sleep 1	##每过1s输出一次结果
    done
}






