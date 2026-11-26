# Cartographier avec TurtleBot3 dans Gazebo

La simulation utilise un TurtleBot3 Burger, Gazebo Classic et ROS 2 Humble. Pour le TurtleBot4 réel, voir le [guide principal](README.md).

Avant de commencer, lisez les [bonnes pratiques du projet](BONNES_PRATIQUES.md).

## Préparer et démarrer le conteneur

Depuis la racine du dépôt, dans un terminal de la session graphique Linux, installez l’image à la première utilisation, puis démarrez le conteneur.

```bash
./bash_scripts/install_turtlebot4_docker.bash
./bash_scripts/start_docker.bash
```

Pour ouvrir un autre terminal dans le conteneur, lancez `./bash_scripts/join_docker.bash` depuis l’hôte.

## Compiler le workspace

Dans le conteneur, à la première utilisation ou après une mise à jour des sources, lancez les commandes suivantes.

```bash
cd "$HOME/simulation_ws"
colcon build --symlink-install && source install/local_setup.bash
```

Les nouveaux terminaux chargent automatiquement le workspace compilé.

## Lancer Gazebo

```bash
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
```

Pour changer de monde, remplacez `turtlebot3_world.launch.py` par `turtlebot3_house.launch.py` ou `turtlebot3_dqn_stage2.launch.py`.

## Lancer le SLAM

Dans le deuxième terminal, démarrez SLAM Toolbox avec l’horloge de Gazebo.

```bash
ros2 launch slam_toolbox online_async_launch.py use_sim_time:=true
```

Dans un autre terminal du conteneur, ouvrez RViz, choisissez `map` comme **Fixed Frame**, puis ajoutez les affichages **Map** (`/map`), **LaserScan** (`/scan`), **RobotModel** et **TF**. Pour **LaserScan**, choisissez la fiabilité **Best Effort**.

```bash
ros2 run rviz2 rviz2 --ros-args -p use_sim_time:=true
```

Comme alternative, Cartographer lance aussi RViz avec une configuration pour le TurtleBot3.

```bash
ros2 launch turtlebot3_cartographer cartographer.launch.py use_sim_time:=true
```

Pour déplacer le robot, développez votre propre nœud de téléopération dans `robmob_ws`.

## Sauvegarder la carte

Exportez la carte pendant que Gazebo et le SLAM tournent.

```bash
mkdir -p "$HOME/maps"
ros2 run nav2_map_server map_saver_cli -f "$HOME/maps/my_map"
```

La carte et ses métadonnées sont enregistrées dans `shared/maps/` sur l’hôte (`my_map.pgm` et `my_map.yaml`).

[Documentation officielle ROBOTIS sur le SLAM en simulation](https://emanual.robotis.com/docs/en/platform/turtlebot3/slam_simulation/)
