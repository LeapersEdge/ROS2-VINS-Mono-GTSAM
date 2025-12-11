# Use official ROS 2 Jazzy base
FROM ros:jazzy-ros-base

# Set environment variables
ENV CERES_VERSION="1.12.0"
ENV ROS2_WS=/root/ros2_ws

# Install build dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    git \
    build-essential \
    libatlas-base-dev \
    libeigen3-dev \
    libgoogle-glog-dev \
    libsuitesparse-dev \
    python3-pip \
    python3-colcon-common-extensions \
    ros-jazzy-cv-bridge \
    ros-jazzy-image-transport \
    ros-jazzy-message-filters \
    ros-jazzy-tf2 \
    && rm -rf /var/lib/apt/lists/*

# Build and install Ceres
RUN git clone https://ceres-solver.googlesource.com/ceres-solver /ceres-solver && \
    cd /ceres-solver && \
    git checkout tags/${CERES_VERSION} && \
    mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc) install && \
    rm -rf /ceres-solver

# Create workspace
RUN mkdir -p $ROS2_WS/src

# Copy VINS-Mono source code
COPY ./ $ROS2_WS/src/VINS-Mono/

# Set working directory
WORKDIR $ROS2_WS

# Build workspace using colcon
RUN . /opt/ros/jazzy/setup.sh && \
    colcon build --symlink-install

# Source the workspace on container start
RUN echo "source $ROS2_WS/install/setup.bash" >> /ros_entrypoint.sh

# Set default environment
ENV TERM xterm
ENV PYTHONIOENCODING UTF-8
