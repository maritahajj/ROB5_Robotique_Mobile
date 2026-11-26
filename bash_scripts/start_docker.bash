#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SHARED_DIR="${SCRIPT_DIR}/../shared"
x11_dir="$SHARED_DIR/.docker-x11"

# Docker keeps its original mounts and environment when a container is restarted.
mkdir -p -m 700 "$x11_dir" || exit 1
xauthority=${XAUTHORITY:-$HOME/.Xauthority}
if [[ -z ${DISPLAY:-} || ! -f $xauthority ]]; then
    xauthority=/dev/null
fi
install -m 600 -- "$xauthority" "$x11_dir/Xauthority" || exit 1
printf '%s\n' "${DISPLAY:-}" > "$x11_dir/display" || exit 1

if running=$(docker container inspect --format '{{.State.Running}}' turtlebot4 2>/dev/null); then
    if [[ $running == true ]]; then
        exec "$SCRIPT_DIR/join_docker.bash"
    fi
    exec docker start -ai turtlebot4
fi

HOST_USER=$(id -un)
HOST_UID=$(id -u)
HOST_GID=$(id -g "$HOST_USER")

mounts=(--volume="$SHARED_DIR:/home/${HOST_USER}:rw")

if [[ -d /tmp/.X11-unix ]]; then
    mounts+=(--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw")
fi

if [[ -d /dev/input ]]; then
    mounts+=(--volume="/dev/input:/dev/input:rw")
fi

exec docker run -it \
    --env=DISPLAY \
    --env="XAUTHORITY=/home/$HOST_USER/.docker-x11/Xauthority" \
    --env=QT_X11_NO_MITSHM=1 \
    --env=LIBGL_ALWAYS_SOFTWARE=1 \
    --env=TURTLEBOT4_CONTAINER=1 \
    "${mounts[@]}" \
    --privileged \
    --network=host \
    --name=turtlebot4 \
    turtlebot4_docker bash -c '
        if [[ $(id -un) != "$1" || $(id -u) != "$2" || $(id -g) != "$3" ]]; then
            echo "L’image Docker ne correspond pas au compte hôte. Supprimez ce conteneur avec docker rm turtlebot4, puis reconstruisez l’image avec ./bash_scripts/install_turtlebot4_docker.bash." >&2
            exit 1
        fi
        exec bash
    ' bash "$HOST_USER" "$HOST_UID" "$HOST_GID"
