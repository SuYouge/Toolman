#!/bin/bash

function main(){

echo '🐳 Starting ros-teleop'
echo 

docker exec \
        -it \
        ros-turtlesim \
        /bin/bash -c  "source ~/.bashrc && rosrun turtlesim turtle_teleop_key "
echo 
echo "📝 ros-teleop Exited "

}

main