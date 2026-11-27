cmake_minimum_required(VERSION 3.8)
project(my_teleop_joy)

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(geometry_msgs REQUIRED)
find_package(sensor_msgs REQUIRED)

add_executable(my_teleop_joy_node src/my_teleop_joy_node.cpp)
target_compile_features(my_teleop_joy_node PRIVATE cxx_std_17)
ament_target_dependencies(my_teleop_joy_node rclcpp geometry_msgs sensor_msgs)

install(TARGETS my_teleop_joy_node DESTINATION lib/${PROJECT_NAME})
install(DIRECTORY launch DESTINATION share/${PROJECT_NAME})

ament_package()
