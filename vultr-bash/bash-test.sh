#!/bin/bash

config=$(cat ./.config)
echo $config

echo "Hello World !"

API_KEY=""

server_list() {
curl "https://api.vultr.com/v1/os/list" | python -mjson.tool
}

show_help() {
echo "Usage: vapi --options"
echo ""
echo "Options:"
echo " -h,     --help             Help menu, provides information on usage."
echo " -ls,    --list-servers     List all servers and information related to account."
}


case $1 in
	""|"-h"|"--help") show_help ;;
	"--list-servers"|"--listserv"|"-ls") server_list ;;
esac
