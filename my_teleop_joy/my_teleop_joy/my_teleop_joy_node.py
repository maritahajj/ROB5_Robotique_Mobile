import rclpy
from geometry_msgs.msg import Twist
from rclpy.node import Node
from rclpy.qos import qos_profile_sensor_data
from sensor_msgs.msg import Joy


class TeleopJoy(Node):
    def __init__(self):
        super().__init__('my_teleop_joy_node')
        self.declare_parameter('axis_linear', 1)
        self.declare_parameter('axis_angular', 0)
        self.velocity_publisher = self.create_publisher(
            Twist, '/turtle1/cmd_vel', 10
        )
        self.joy_subscription = self.create_subscription(
            Joy, '/joy', self.on_joy, qos_profile_sensor_data
        )

    def on_joy(self, msg):
        linear_axis = self.get_parameter('axis_linear').value
        angular_axis = self.get_parameter('axis_angular').value

        command = Twist()
        if 0 <= linear_axis < len(msg.axes):
            command.linear.x = 2.0 * msg.axes[linear_axis]
        if 0 <= angular_axis < len(msg.axes):
            command.angular.z = 2.0 * msg.axes[angular_axis]

        self.velocity_publisher.publish(command)


def main(args=None):
    rclpy.init(args=args)
    node = TeleopJoy()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.try_shutdown()
