#!/bin/bash

config=$(cat ./.config)
API_KEY=${config:$(expr $(expr index $config KEY= ) + 3):37}

server_list() {
curl -H "API-Key: $API_KEY" https://api.vultr.com/v1/server/list | python -mjson.tool |awk '/DCID/||/os/||/SUBID/||/VPSPLANID/||/default_password/||/main_ip/||/power_status/||/server_state/||/status/'| tr '"' ' '| tr ',' ' '
}

account_info(){
curl -H "API-Key: $API_KEY" https://api.vultr.com/v1/account/info | python -mjson.tool
}


os_info(){
curl https://api.vultr.com/v1/os/list | python -mjson.tool
}

key_info(){
echo "In KEY mode"
curl -H "API-Key: $API_KEY" "https://api.vultr.com/v1/auth/info" | python -mjson.tool
}

# 有额外选项 指定计划的类型
plans_info(){
echo "可以添加参数 如-vd2"
echo "vd2 				not just cloud compute"
echo "ssd				cloud compute"
echo "vdc2				Dedicated Cloud"
echo "dedi		 		Dedicated Cloud"
echo "vc2z				HightFrequency"
read -p "Enter some plans type mode > " pltype
curl https://api.vultr.com/v1/plans/list?type=$pltype | python -mjson.tool|awk '/VPSPLANID/||/price_per_month/'|awk 'ORS=NR%2?" ":"\n"{print}'| tr '"' ' '| tr ',' ' '
}


# 可以有额外选项 显示指定区域可用的计划
region_info(){
# curl https://api.vultr.com/v1/regions/list | python -mjson.tool
curl https://api.vultr.com/v1/regions/list |python -mjson.tool |awk '/DCID/||/country/'|sed -n '{N;s/\n/\t/p}'
echo "add DCID as parameter for detailed information or (Q/q) to quit"
read -p "Enter DCID > " DCID
if [[ "$DCID" == "q"||"$DCID" == "Q" ]]; # 等号两边要有空格
then
    echo "Quit"
else
    curl https://api.vultr.com/v1/regions/availability?DCID=$DCID |python -mjson.tool
fi
}

show_help() {
echo "Usage: bash-test.sh --options"
echo ""
echo "Options:"
echo " -i      --interactive      Use as interactive mode"
echo " -h,     --help             Help menu, provides information on usage."
echo " -ls,    --list-servers     List all servers and information related to account."
echo " -acc,   --account          Account information"
echo " -os,    --operating-system Information abou os"
echo " -plan,  --plans            Plans information"
echo " -reg,   --region           Avaliable region"
echo " -key,   --keys             API key"
echo " -cre,   --create           Create servers"
}

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
curl -H "API-Key: $API_KEY" https://api.vultr.com/v1/server/create --data "DCID=$DCID" --data "VPSPLANID=$VPSPLANID" --data "OSID=$OSID"
}

get_userdata(){
curl -H "API-Key: $API_KEY" https://api.vultr.com/v1/server/get_user_data?SUBID=32110861
}

interactive_mode(){
echo "Options:"
echo " os 						Information abou os"
echo " plan,  	plan            Plans information"
echo " account,	act           	Account information"
echo " reg,   	region         	Avaliable region"
echo " key,   	keys,	k     	API key"
echo " servers,	serv,	ls    	List all servers and information related to account."
echo " cre,   	create         	Create servers"
echo " get,   	getdata        	Get userdata"

read -p "Enter modeID > " modeID
case $modeID in
	"servers"|"serv"|"ls") 
		server_list ;;
	"account"|"act") 
		account_info ;;
	"os") 
		os_info ;;
	"plans"|"plan") 
		plans_info ;;
	"region"|"reg") 
		region_info ;;
	"keys"|"key"|"k") 
		key_info ;;
	"cre"|"create"|"c") 
		create_server ;;
esac
}


destroy_server(){
	SUBID=$(curl -H "API-Key: $API_KEY" https://api.vultr.com/v1/server/list | python -mjson.tool |awk '/SUBID/'| tr '"' ' '| tr ',' ' '|awk -F ' :  ' '{print $2}')
	# echo $SUBID
	curl -H "API-Key: $API_KEY" https://api.vultr.com/v1/server/destroy --data "SUBID=$SUBID"
}


auto_mode(){
	server_state=$(curl -H "API-Key: $API_KEY" https://api.vultr.com/v1/server/list | python -mjson.tool |awk '/default_password/||/main_ip/'|grep -v  "v6"| tr '"' ' '| tr ',' ' '|awk -F ' :  ' '{print $2}')
	# echo $server_state
	paswd=${server_state%$'\n'*}
	echo "password is $paswd"
	tempip=${server_state#*$'\n'}
	echo "temp-ip is $tempip"
	tempuser="root"
	echo "temp-user is $tempuser"
	ssh -p 22 $tempuser@$tempip
}

case $1 in
	"")
		auto_mode ;;
	"-h"|"--help") 
		show_help ;;
	"--list-servers"|"--listserv"|"-ls") 
		server_list ;;
	"--account"|"--accounts"|"-acc") 
		account_info ;;
	"--operating-system"|"-os") 
		os_info ;;
	"--plans"|"-plan") 
		plans_info ;;
	"--region"|"-reg") 
		region_info ;;
	"--keys"|"-key") 
		key_info ;;
	"--interactive"|"-i") 
		interactive_mode ;;
	"--create"|"-cre") 
		create_server ;;
	"--getdata"|"-get") 
		get_userdata ;;
	"--destroy-server"|"-d") 
		destroy_server ;;
esac
