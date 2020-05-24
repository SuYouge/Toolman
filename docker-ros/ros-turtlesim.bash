#!/bin/bash

function main(){

echo '🐳 Starting ros-turtlesim-node'
echo 

docker exec \
        -it \
        ros-turtlesim \
        /bin/bash -c "source ~/.bashrc && rosrun turtlesim turtlesim_node" 
echo 
echo "📝 ros-turtlesim-node Exited "

}

main