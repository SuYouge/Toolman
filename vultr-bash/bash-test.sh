#!/bin/bash
#echo "Hello World !"

API_KEY=${config:$(expr $(expr index "$(cat ./.config)" KEY= ) + 3):37}


server_list() {
curl -H "API-Key: $API_KEY" https://api.vultr.com/v1/os/list | python -mjson.tool
}

account_info(){
curl -H "API-Key: $API_KEY" https://api.vultr.com/v1/account/info | python -mjson.tool
}

show_help() {
echo "Usage: vapi --options"
echo ""
echo "Options:"
echo " -h,     --help             Help menu, provides information on usage."
echo " -ls,    --list-servers     List all servers and information related to account."
echo " -acc,   --account          Account information"
}


case $1 in
	""|"-h"|"--help") show_help ;;
	"--list-servers"|"--listserv"|"-ls") server_list ;;
	"--account"|"--accounts"|"-acc") account_info ;;
esac
