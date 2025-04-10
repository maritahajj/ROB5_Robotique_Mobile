docker run -it --rm \
--env="DISPLAY" \
--env="QT_X11_NO_MITSHM=1" \
--env="LIBGL_ALWAYS_SOFTWARE=1" \
--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--volume="$XAUTHORITY:/dot.Xauthority" \
--mount type=bind,source="$(pwd)"/home,target=/home \
--privileged \
--net="host" \
--name="turtlebot4" \
--workdir="/home" \
turtlebot4_docker

# Add this line before the "turtlebot4_docker" line to mount another directory
# The directory needs to exist in your host OS
# --mount type=bind,source=/your/dir/path,target=/home/path/in/container \
