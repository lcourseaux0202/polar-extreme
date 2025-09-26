# T3 25 SCI25 A  

## Cahier des charges  

### 1. Présentation du projet

#### 1.1. Nom du jeu
Polar Extreme

#### 1.2. Type de jeu
Jeu de gestion en 2D vue de dessus (Rimworld like)

### 2. Contexte & objectifs

#### 2.1. Objectifs
Comprendre les enjeux scientifiques, humains et environnementaux liés à l’implantation et à la gestion d’une station de recherche en Antarctique, un milieu extrême hostile.  

- **Comprendre l’environnement de l'Antarctique**
  Identifier les caractéristiques géographiques, climatiques et les contraintes de vie liées à ce milieu extrême et isolé.  

- **Relever les défis techniques et logistiques**
  Analyser les enjeux de conception, de construction et de gestion durable d'une station scientifique en Antarctique.  

- **Explorer les dimensions humaines**
  Comprendre les impacts psychologiques, culturels et sociaux de la vie en communauté dans un environnement isolé et multiculturel.  

#### 2.2. Contraintes
- Date début : 3 septembre 2025
- Date fin : 19 décembre 2025
- Equipe de 4 personnes

### 3. Description du gameplay

#### 3.1. Vue & style
- 2D
- Vue de dessus
- Pixel art 

#### 3.2. Mécaniques principales
- Gestion d'une base polaire passant par
  - Construction / amélioration de bâtiments
  - Engagement de scientifiques (pnjs) permettant l'exploitation de ces bâtiments
  - Construction de chemins permettant de relier ces batîments et d'y conduire les scientifiques
- Production d'une monnaie / score appelée **Science** via la construction et la gestion de bâtiments
- Limite de temps avec score final

#### 3.3. Durée de vie
- 30 minutes de jeu pour une première partie
- 2 fins possibles :
  - Arriver à la fin du temps imparti : victoire & score
  - Base s'effondre avant la fin du temps imparti : défaite & 0 point

### 4. Spécifications techniques

#### 4.1. Moteur de jeu
Godot 4 (GDScript)

#### 4.2. Plateformes visées
- Windows
- Linux

### 5. Direction artistique

#### 5.1. Graphismes
- Pixel art 32px
- Couleurs dominantes : blanc & bleu

#### 5.2. Interface utilisateur
- UI moyennement chargée
- Souris + clavier (possibilité de jouer uniquement souris)

#### 5.3. Inspirations visuelles
- Rimworld

## Explications avancées des mécaniques 

### Menu du jeu
- 3 options disponibles :
  - Nouvelle partie
  - Paramètres
  - Quitter
- Si possible : 4eme option pour voir les scores sur un site web

### Paramètres
- Résolution
- Plein écran
- VSync
- Volume
  - Effets sonores
  - Musiques
- Sélection avec clic droit ou clic gauche

### En jeu

#### UI





















### Concept  
- Rimworld simplifié  
- Design : pixel art 2D vu du dessus  
- Builder style trackmania (construction modulaire et rapide)  

### Mécaniques principales  
- Optimiser production de science
- Utiliser science comme points pour débloquer bâtiments, engager des scientifiques
- Jauge écologique  
- Jauge de bien-être des scientifiques  
  - 0% = death  
  - 100% = ultra productif  
  - Démarrage à 30% 
- Chemins dans la neige  
  - Pas de chemin = scientifique perdu et mort 

### Tutoriel "caché"
- Joueur guidé indirectement  

### Rôle des scientifiques  
- Début : généralistes (pas de spécialisation)  
- Progression : spécialisation (médecine, géologie, kebaberie, etc.)  

### Projets de recherche  
- Chaque projet = taux de risque  
  - Plus de risque = plus de récompenses, mais plus de chance de flop  
- **Jauge de risques** :  
  - Chaque lancement de projet = probabilité d’échec plus ou moins forte  
  - En cas d'échec : impact sur bien-être des scientifiques et/ou impact sur l'écologie
- **Tableau des projets en cours** :  
  - Affiché sur le côté gauche de la zone de jeu (déroulant)
  -   

### Bien-être   
- Jauge de bien-être :  
  - Influence sur l’efficacité des projets  
  - Influence sur le niveau de risques 
- Beaucoup de bâtiments ont une influence sur le bien-être et la productivité  
- Animaux de compagnie  
  - Un peu = boost  
  - Trop = chaos  

### Ressources  
- Science  
- Confiance de l’État  

### Jauges principales  
- **Science**  
  - Affichée en haut à gauche  
  - Production dépend des projets actifs  
  - Arbre de progression : débloque de nouveaux bâtiments ou augmente les limites  
- **Bien-être**
  - Déterminé par de nombreux facteurs : qualité des batîments, surpopulation, propreté, etc...
  - Influe sur la productivité de "science"  
- **Productivité**  
  - Nombre d’unités de science produites par jour (ou temps réel, à discuter)  
- **Écologie**  
  - Respect de l'environnement par achat de bâtiments éco-responsables et nettoyage de la zone  
  - Influence sur les événements aléatoires (tempêtes, etc.)  

### Environnement & écologie  
- **Énergie**  
  - Pétrole = polluant  
  - Éolienne = durable  
  - Panneau solaire = efficace la moitié de l’année  
- **Milieu**  
  - Température  
  - Météo  
  - Événements aléatoires liés à l’écologie  

### Gameplay & Interface  
- Drag & drop pour les mouvements  
- Gestion stratégique des jauges et projets  
- Équilibre entre survie, productivité et respect de l’écologie  
- Folder a gauche pour la gestion des projects
- Folder à droite pour la gestion des pnj
- **Interaction bâtiments** :  
  - Cliquer sur un bâtiment = zoom  
  - Ouverture d’un menu à droite  
  - Interface de création intérieure du bâtiment (choisir ce qu’on installe à l’intérieur)  
  - Visualisation en temps réel de ce qui se passe dans le bâtiment  
  - Filtre noir pour assombrir le reste de la zone (focus sur le bâtiment)  
- **Interaction pnj** :
  - Cliquer sur un pnj = zoom
  - Bulle apparaît au dessus de sa tête avec une indication de ce qu'il désire (tuto ambulant)
  - Apparition d'autres informations dans un menu (au-dessus de sa tête ou dans un cadre à part, à discuter)
  - Possiblité d'affilier des formations en secourisme, cuisine, etc... 
