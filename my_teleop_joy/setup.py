from setuptools import find_packages, setup

package_name = 'my_teleop_joy'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/my_teleop_joy/launch', ['launch/teleop.launch.py']),
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='antoine',
    maintainer_email='antoine@todo.todo',
    description='TODO: Package description',
    license='TODO: License declaration',
    extras_require={
        'test': [
            'pytest',
        ],
    },
    entry_points={
        'console_scripts': [
            'my_teleop_joy_node = my_teleop_joy.my_teleop_joy_node:main',
        ],
    },
)
