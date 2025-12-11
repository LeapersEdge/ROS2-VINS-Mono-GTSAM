cmake_minimum_required(VERSION 3.5)
project(pose_graph)

set(CMAKE_BUILD_TYPE "Release")
set(CMAKE_CXX_FLAGS "-std=c++17")
#-DEIGEN_USE_MKL_ALL")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -Wall -g")


set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rcpputils REQUIRED)
find_package(std_msgs REQUIRED)
find_package(nav_msgs REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(visualization_msgs REQUIRED)
find_package(cv_bridge REQUIRED)
find_package(tf2 REQUIRED)
find_package(tf2_ros REQUIRED)
find_package(camera_model REQUIRED)
find_package(image_transport REQUIRED)
find_package(ament_index_cpp REQUIRED)

include_directories("../camera_models/include")

find_package(GTSAM REQUIRED)
find_package(OpenCV REQUIRED)
find_package(Ceres REQUIRED)
find_package(Eigen3 REQUIRED)
find_package(Boost REQUIRED)

include_directories(${CERES_INCLUDE_DIRS} ${EIGEN3_INCLUDE_DIR} ${GTSAM_INCLUDE_DIR} ${cv_bridge_INCLUDE_DIRS})
link_directories(${GTSAM_LIBRARY_DIRS})


add_executable(pose_graph
    src/pose_graph_node.cpp
    src/pose_graph.cpp
    src/keyframe.cpp
    src/utility/CameraPoseVisualization.cpp
    src/ThirdParty/DBoW/BowVector.cpp
    src/ThirdParty/DBoW/FBrief.cpp
    src/ThirdParty/DBoW/FeatureVector.cpp
    src/ThirdParty/DBoW/QueryResults.cpp
    src/ThirdParty/DBoW/ScoringObject.cpp
    src/ThirdParty/DUtils/Random.cpp
    src/ThirdParty/DUtils/Timestamp.cpp
    src/ThirdParty/DVision/BRIEF.cpp
    src/ThirdParty/VocabularyBinary.cpp
)

# add_executable(Trial src/Trial.cpp)

ament_target_dependencies(pose_graph rclcpp rcpputils std_msgs sensor_msgs visualization_msgs geometry_msgs nav_msgs tf2 tf2_ros cv_bridge camera_model image_transport ament_index_cpp)


target_link_libraries(pose_graph ${CERES_LIBRARIES} ${OpenCV_LIBS} gtsam)

message(${OpenCV_LIBS})
# target_link_libraries(Trial ${catkin_LIBRARIES}  ${CERES_LIBRARIES} ${OpenCV_LIBS} gtsam)

# message("message" ${gtsam})
# message("catkin_lib  ${catkin_LIBRARIES}")

# Install nodes
install(
  TARGETS pose_graph
  DESTINATION lib/${PROJECT_NAME}
)

ament_package()

