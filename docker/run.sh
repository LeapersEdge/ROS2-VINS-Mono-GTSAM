#!/bin/bash
trap : SIGTERM SIGINT

function abspath() {
    # generate absolute path from relative path
    if [ -d "$1" ]; then
        (cd "$1"; pwd)
    elif [ -f "$1" ]; then
        if [[ $1 = /* ]]; then
            echo "$1"
        elif [[ $1 == */* ]]; then
            echo "$(cd "${1%/*}"; pwd)/${1##*/}"
        else
            echo "$(pwd)/$1"
        fi
    fi
}

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 LAUNCH_FILE" >&2
  exit 1
fi

# Launch RViz in background
rviz2 -d ../config/vins_rviz_config.rviz &
RVIZ_PID=$!

VINS_MONO_DIR=$(abspath "..")

# Run VINS-Mono inside Jazzy Docker
docker run \
  -it \
  --rm \
  --net=host \
  -v ${VINS_MONO_DIR}:/root/ros2_ws/src/VINS-Mono/ \
    jazzy-vins-mono \
    /bin/bash -c "\
    cd /root/ros2_ws/; \
    source /opt/ros/jazzy/setup.bash; \
    colcon build --symlink-install --executor sequential; \
    source install/setup.bash; \
    ros2 launch vins_estimator ${1} \
  "

wait $RVIZ_PID

if [[ $? -gt 128 ]]; then
    kill $RVIZ_PID
fi

