#!/bin/bash

ROSTURTLE_IMAGE_VERSION="ros_turtlesim:latest"

function main(){

echo '🐳 Starting ros-core'
echo 

docker run \
        --name ros-turtlesim \
        --rm \
        -it \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=unix${DISPLAY} \
        "$ROSTURTLE_IMAGE_VERSION"
        # /bin/bash -c "roscore"
echo 
echo "📝 ros-core Exited "

}
main