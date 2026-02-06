# TURTLEBOT4

## Table des matières
1. [Description](#description)
2. [Mise en place de l'environnement Docker](#mise-en-place-de-lenvironnement-docker)
3. [Démarrer le turtlebot4](#démarrer-le-turtlebot4)
3. [Projet](#projet)
   1. [Déplacement du robot](#déplacement-du-robot)
   2. [Génération de la carte](#génération-de-la-carte)
   3. [Post-traitement de la carte](#post-traitement-de-la-carte)

## Description
Le projet a pour but d'effectuer un algorithme de SLAM (Simultaneous Localization and Mapping) avec le robot Turtlebot4.
Lien vers la documentation du turtlebot4 : https://turtlebot.github.io/turtlebot4-user-manual/

## Mise en place de l'environnement Docker
Récupérer le dossier dans le gitlab associé : https://gitlabsu.sorbonne-universite.fr/polytech_rob/robots/turtlebot/turtlebot4_env_docker/-/tree/main?ref_type=heads
Puis lancer les scripts suivants en fonction de ce que vous souhaitez réaliser qui se situent dans le dossier bash_scripts :
- Installer docker : `install_docker.bash`
- Installer le docker turtlebot4 : `install_turtlebot4_docker.bash`
- Lancer le docker turtlebot4 : `start_docker.bash`
- Ouvirir un nouveau terminal dans le docker : `join_docker.bash`
- Désinstaller le docker : `uninstall_docker.bash`

Une fois le docker démarré, il faut mettre la bonne adresse IP du robot et le bon domaine ID dans le .bashrc du docker (information à récupérer sur l'étiquette du robot)
La fonction ros_turtle permet de configurer l'environnement ROS2 pour le turtlebot4 :
```bash
# ROS turtle
ros_turtle() {
    # ROS SOURCE
    export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
    source /opt/ros/humble/setup.bash


    #[ -t 0 ] && export ROS_SUPER_CLIENT=True || export ROS_SUPER_CLIENT=False
    export ROS_SUPER_CLIENT=True
    export ROS_DOMAIN_ID= DOMAINE_ID_TURTLEBOT
    export ROS_DISCOVERY_SERVER=ADRESSE_IP_TURTLEBOT:11811
    PS1="(humble turtle) $PS1"
}
```
Enfin se connecter au réseau wifi des turtlebot4 :
```angular2html
Nom du réseau : Turtlebot_TP_5G
Mot de passe : turtlebotTP
```

## Démarrer le turtlebot4
1. Allumer le Turtlebot4 en le plaçant sur le socle de recharge et attendre le bruit de fin de démarrage.
2. L'accès ssh se fait via la commande suivante:
```
ssh ubuntu@IP_TURTLEBOT
mdp: turtlebot4
```
3. Lancer l'environnement ROS2 de son docker avec la commande suivante dans son terminal :
```angular2html
ros_turtle
```
Avant d'effectuer d'autre commande il faut relancer daemon pour obtenir tous les topics du robot :
```angular2html
ros2 daemon stop
ros2 daemon start
```
ou
```angular2html
ros_daemon_restart
```
Remarque : Il faut souvent relancer cette commande si on effectue des changements de configuration de l'environnement ROS2 sinon ils ne sont pas pris en compte.
On peut vérifier que la communication est bien établie en lançant la commande sur un terminal du docker et sur le robot puis comparer les topics :
```angular2html
ros2 topic list
```
On doit obtenir la liste des topics ROS2 du robot :
```angular2html
/battery_state
/cliff_intensity
/cmd_audio
/cmd_lightring
/cmd_vel
/color/preview/image
/diagnostics
/diagnostics_agg
/diagnostics_toplevel_state
/dock_status
/function_calls
/hazard_detection
/imu
/interface_buttons
/ip
/ir_intensity
/ir_opcode
/joint_states
/joy
/joy/set_feedback
/kidnap_status
/mobility_monitor/transition_event
/mouse
/oakd/rgb/preview/camera_info
/oakd/rgb/preview/image_raw
/oakd/rgb/preview/image_raw/compressed
/oakd/rgb/preview/image_raw/compressedDepth
/oakd/rgb/preview/image_raw/theora
/odom
/parameter_events
/robot_description
/robot_state/transition_event
/rosout
/scan
/slip_status
/static_transform/transition_event
/stereo/depth
/stop_status
/tf
/tf_static
/wheel_status
/wheel_ticks
/wheel_vels
```

## Projet
### Déplacement du robot
Pour déplacer le robot dans l'environnement, il est possible d'utiliser le package teleop_twist_keyboard avec la commande :
```
ros2 run teleop_twist_keyboard teleop_twist_keyboard
```
On peut alors utiliser les touches i et j pour faire tourner et avance le turtlebot.

### Génération de la carte
Pour générer une carte il faut lancer la commande suivante depuis votre docker :
```
ros2 launch turtlebot4_navigation slam.launch.py
```
Attention, il est important de lancer cette commande depuis le docker et non depuis le robot pour un bon fonctionnement du slam.
Pour visualiser dans Rviz la carte générée en temps réel, il faut lancer la commande suivante :
```
ros2 launch turtlebot4_viz view_robot.launch.py
```
Pour sauvegarder la carte générée, il faut lancer la commande suivante :
```
ros2 service call /slam_toolbox/save_map slam_toolbox/srv/SaveMap "name: {data: 'map_name'}"
```
Si erreur de type :
```
Failed to populate field: 'SaveMap_Request' object has no attribute 'name:data'
```
alors essayer :
```
ros2 run nav2_map_server map_saver_cli -f map_name
```
On a alors deux fichiers (__map_name.pgm__ et __map_name.yaml__) qui sont générés.

### Post-traitement de la carte
Il est possible de post-traiter la carte générée à l'aide du package Opencv. Voici un exemple de script python pour post-traiter la carte :
```python
import cv2
# Load the map.pgm
map = cv2.imread('my_map.pgm', cv2.IMREAD_GRAYSCALE)
```
Dans le fichier yaml, on peut récupérer les informations de résolution (m/pixel) de la carte.
