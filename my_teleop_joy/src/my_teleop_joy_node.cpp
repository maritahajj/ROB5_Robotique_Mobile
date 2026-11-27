#include <cstddef>
#include <cstdint>
#include <memory>

#include "geometry_msgs/msg/twist.hpp"
#include "rclcpp/rclcpp.hpp"
#include "sensor_msgs/msg/joy.hpp"

class TeleopJoy : public rclcpp::Node
{
public:
  TeleopJoy()
  : Node("my_teleop_joy_node")
  {
    declare_parameter("axis_linear", 1);
    declare_parameter("axis_angular", 0);

    velocity_publisher_ = create_publisher<geometry_msgs::msg::Twist>(
      "/turtle1/cmd_vel", 10);

    joy_subscription_ = create_subscription<sensor_msgs::msg::Joy>(
      "/joy", rclcpp::SensorDataQoS(),
      [this](sensor_msgs::msg::Joy::ConstSharedPtr msg) {on_joy(*msg);});
  }

private:
  static double axis_value(const sensor_msgs::msg::Joy & msg, std::int64_t index)
  {
    if (index < 0 || static_cast<std::size_t>(index) >= msg.axes.size()) {
      return 0.0;
    }
    return msg.axes[static_cast<std::size_t>(index)];
  }

  void on_joy(const sensor_msgs::msg::Joy & msg)
  {
    geometry_msgs::msg::Twist command;
    command.linear.x = 2.0 * axis_value(msg, get_parameter("axis_linear").as_int());
    command.angular.z = 2.0 * axis_value(msg, get_parameter("axis_angular").as_int());
    velocity_publisher_->publish(command);
  }

  rclcpp::Publisher<geometry_msgs::msg::Twist>::SharedPtr velocity_publisher_;
  rclcpp::Subscription<sensor_msgs::msg::Joy>::SharedPtr joy_subscription_;
};

int main(int argc, char ** argv)
{
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<TeleopJoy>());
  rclcpp::shutdown();
  return 0;
}
