export TURTLEBOT4_DOC_ID=$(docker ps -aqf "name=turtlebot4")

docker exec -it \
--env="DISPLAY" \
--env="QT_X11_NO_MITSHM=1" \
--env="LIBGL_ALWAYS_SOFTWARE=1" \
--privileged \
--workdir="/home" \
$TURTLEBOT4_DOC_ID bash

# Add this line before the "turtlebot4_docker" line to mount another directory
# The directory needs to exist in your host OS
# --mount type=bind,source=/your/dir/path,target=/home/path/in/container \
