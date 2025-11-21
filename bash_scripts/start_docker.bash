docker run -it --rm \
--env="DISPLAY" \
--env="QT_X11_NO_MITSHM=1" \
--env="LIBGL_ALWAYS_SOFTWARE=1" \
--env="TURTLEBOT4_CONTAINER=1" \
--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--volume="$XAUTHORITY:/dot.Xauthority" \
--volume="./shared:/home/$(id -un):rw" \
--volume="/dev/input:/dev/input:rw" \
--privileged=true \
--net="host" \
--name="turtlebot4" \
--user="$(id -u)":"$(id -g)" \
turtlebot4_docker

# Add this line before the "turtlebot4_docker" line to mount another directory
# The directory needs to exist in your host OS
# --mount type=bind,source=/your/dir/path,target=/home/path/in/container \
