# Use official ROS 2 Jazzy base
FROM ros:jazzy-ros-base

# Set environment variables
ENV CERES_VERSION="1.14.0"
ENV GTSAM_VERSION="4.2"
ENV EIGEN_VERSION="3.3.7"
ENV ROS2_WS=/root/ros2_ws

# Install build dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    git \
    wget \
    build-essential \
    libboost-all-dev \
    libatlas-base-dev \
    libgoogle-glog-dev \
    libsuitesparse-dev \
    python3-pip \
    python3-colcon-common-extensions \
    ros-jazzy-cv-bridge \
    ros-jazzy-image-transport \
    ros-jazzy-message-filters \
    ros-jazzy-tf2 \
    && rm -rf /var/lib/apt/lists/*

# Build and install eigen
RUN cd / && \
wget https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_VERSION}/eigen-${EIGEN_VERSION}.tar.bz2 && \
tar -xvf eigen-${EIGEN_VERSION}.tar.bz2 && \
cd /eigen-${EIGEN_VERSION} && \
mkdir build && cd build && \
cmake .. && \
make -j$(nproc) install && \
rm -rf /eigen-${EIGEN_VERSION}

# Build and install Ceres
RUN cd / && \
    wget http://ceres-solver.org/ceres-solver-${CERES_VERSION}.tar.gz && \
    tar -xvf ceres-solver-${CERES_VERSION}.tar.gz && \
    cd ceres-solver-${CERES_VERSION} && \
    mkdir build && \ 
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DSUITESPARSE=OFF -DBUILD_TESTING=OFF && \
    make -j$(nproc) install && \
    rm -rf /ceres-solver-${CERES_VERSION} 


# Build and install GTSAM
RUN cd / && \
    wget https://github.com/borglab/gtsam/archive/refs/tags/${GTSAM_VERSION}.tar.gz && \
    tar -xvf ${GTSAM_VERSION}.tar.gz && \
    cd /gtsam-${GTSAM_VERSION} && \
    mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc) install && \
    rm -rf /gtsam-${GTSAM_VERSION}

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
