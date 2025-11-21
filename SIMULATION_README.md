# TURTLEBOT 3 GAZEBO

Comment réaliser une cartographie de l'environnement avec la simulation Turtlebot 3 ?

## Table des matières

1. [Démarrer le docker turtlebot4](#démarrer-le-docker-turtlebot4)
2. [Build simulation_ws](#build-simulation_ws)
3. [Lancer la simulation turtlebot3](#lancer-la-simulation-turtlebot3)
4. [Lancement du SLAM](#lancement-du-slam)
5. [Visualisation de la carte](#visualisation-de-la-carte)
6. [Sauvegarde de la carte](#sauvegarde-de-la-carte)

## Démarrer le docker turtlebot4

```bash
./bash_scripts/start_docker.bash
```

puis pour avoir autant de terminaux que souhaité à l'intérieur du container
vous pouvez lancer **terminator** dans le container turtlebot4

```bash
terminator
```

## Build simulation_ws

La première fois que vous utilisez ce container, il faut build le workspace de simulation.
Pour cela, il faut se placer dans le dossier simulation_ws puis lancer la commande colcon build

```bash
cd simulation_ws
colcon build --symlink-install
source install/setup.bash
```

## Lancer la simulation turtlebot3

```bash
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
```

Vous pouvez très bien utiliser un autre monde comme par exemple :

```bash
ros2 launch turtle3_gazebo turtlebot3_dqn_stage2.launch.py
```

```bash
ros2 launch turtlebot3_gazebo turtlebot3_house.launch.py
```

## Lancement du SLAM

Il existe plusieurs packages de SLAM pour ROS2, parmi eux :

- slam_toolbox
- cartographer

```bash
ros2 launch slam_toolbox online_async_launch.py use_sim_time:=True
```

ou encore

```bash
ros2 launch turtlebot3_cartographer cartographer.launch.py use_sim_time:=True
```

Cette commande lancera aussi RVIZ2 avec une configuration par défaut.

## Visualisation de la carte

Lancer RVIZ2

```
ros2 run rviz2 rviz2
```

Vous pouvez ajouter les éléments suivants dans RVIZ2 par exemple :

- RobotModel
- LaserScan
- Map
- TF

Il sera préférable par la suite de créer sa propre configuration RVIZ2
et de lancer RVIZ2 avec cette configuration via un launch file.

Pour sauvegarder votre configuration RVIZ2, aller dans **File -> Save Config As...**
Et sauvegarder le fichier dans un nouveau dossier **rviz** se trouvant dans un package de votre workspace **robmob_ws**.

Puis ajouter le chemin de ce fichier dans la configuration de votre package.
Par exemple dans le setup.py de votre package :

```python
data_files=[
        ("share/" + package_name + "/rviz", glob(os.path.join("rviz", "*.rviz"))),
    ],
```

## Sauvegarde de la carte

Pour sauvegarder la carte générée, il faut lancer la commande suivante :

```bash
ros2 run nav2_map_server map_saver_cli -f my_map
```

Cela générera deux fichiers **my_map.pgm** et **my_map.yaml** dans le dossier courant.
