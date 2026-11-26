# Bonnes pratiques du projet Robotique mobile

## Workspaces ROS 2

- Réservez `simulation_ws` à la compilation du simulateur fourni. Laissez ses sources telles qu’elles sont fournies et suivez le [guide de simulation](SIMULATION_README.md).
- Développez le code du projet, y compris votre nœud de téléopération, dans `robmob_ws`.

## Un dépôt Git par binôme

Créez un dépôt distant commun et donnez l’accès aux deux membres du binôme. Après l’installation de l’environnement, chacun le clone dans le dossier vide `shared/robmob_ws/src/`. Depuis la racine du dépôt Docker sur l’hôte, remplacez `URL_DU_DEPOT` par l’adresse du dépôt commun.

```bash
git clone URL_DU_DEPOT shared/robmob_ws/src
```

`src/` est la racine du dépôt Git du binôme. Placez-y directement tous vos packages ROS 2.

Dans votre IDE sur l’hôte, ouvrez `shared/robmob_ws/` comme dossier de projet. Dans le conteneur, lancez `colcon build --symlink-install` depuis `$HOME/robmob_ws/`. Les dossiers `build/`, `install/` et `log/` sont générés à côté de `src/`, hors du dépôt Git du binôme.

### Autocomplétion C++ dans VS Code (facultatif)

Démarrez `turtlebot4`. Avec l’extension **Dev Containers**, lancez **Dev Containers: Attach to Running Container…**, sélectionnez `turtlebot4` et ouvrez `/home/<utilisateur>/robmob_ws/` dans la fenêtre connectée. Installez l’extension **C/C++** dans le conteneur.

Dans le terminal intégré, compilez depuis `robmob_ws/` en demandant à CMake d’exporter les options de compilation.

```bash
colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

Dans **C/C++: Edit Configurations (UI)**, renseignez **Compile commands** avec `${workspaceFolder}/build/compile_commands.json`. IntelliSense utilisera les chemins du compilateur pour résoudre les `#include` ROS 2 et proposer l’autocomplétion. [Documentation IntelliSense](https://code.visualstudio.com/docs/cpp/configure-intellisense)

## Utiliser le conteneur Docker

- **Fichiers de travail.** Le dossier `shared/` sur l’hôte est monté comme `$HOME` dans le conteneur. Travaillez dans ce dossier pour retrouver vos fichiers sur l’hôte, même après avoir recréé le conteneur.
- **Configuration du terminal.** `shared/.bashrc` est fourni par le dépôt Docker. Chaque nouveau terminal du conteneur le charge pour configurer ROS 2 et les workspaces déjà compilés. Utilisez `shared/.bash_aliases` pour vos alias personnels.
- **Reprise entre les séances.** Depuis l’hôte, lancez `./bash_scripts/start_docker.bash`. Le script démarre le conteneur sans `--rm`. `exit` dans le premier terminal arrête le conteneur, et le prochain lancement reprend le même conteneur avec les bibliothèques installées.
- **Dépendances supplémentaires.** L’image Docker contient les dépendances prévues pour le projet. Si vous en ajoutez une, indiquez-la dans le dépôt du binôme. Réservez `sudo` aux tâches d’administration, comme l’installation d’un paquet système.

Pour repartir de l’image commune, quittez le conteneur, puis exécutez `docker rm turtlebot4` sur l’hôte et relancez `start_docker.bash`. Cette opération efface les installations effectuées dans le conteneur. Les fichiers de `shared/` restent sur l’hôte.
