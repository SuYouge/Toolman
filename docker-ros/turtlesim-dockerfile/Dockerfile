FROM ros:melodic-robot-stretch
# 镜像构建好慢
RUN  apt-get update && apt-get install -y \
        ros-melodic-turtlesim \
        && apt-get autoremove -y \
        && apt-get clean \
        && rm -fr /tmp/* \
        && rm -rf /var/lib/apt/lists/ \
        && echo 'source /opt/ros/melodic/setup.bash'>> ~/.bashrc
