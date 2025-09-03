# T3 25 SCI25 A  

base scientifique au pôle nord  

projet :  
- gdscript  
- commit en minuscule et en anglais  
- snake_case  

## Cahier des charges  

### Objectif pédagogique  
Comprendre les enjeux scientifiques, humains et environnementaux liés à l’implantation et à la gestion d’une station de recherche en Antarctique, un milieu extrême hostile.  

### Objectifs pédagogiques avancés  
1. **Comprendre l’environnement de l'Antarctique**  
   Identifier les caractéristiques géographiques, climatiques et les contraintes de vie liées à ce milieu extrême et isolé.  

2. **Relever les défis techniques et logistiques**  
   Analyser les enjeux de conception, de construction et de gestion durable d'une station scientifique en Antarctique.  

3. **Explorer les dimensions humaines**  
   Comprendre les impacts psychologiques, culturels et sociaux de la vie en communauté dans un environnement isolé et multiculturel.  

## Brainstorming  

### Concept  
- Rimworld simplifié  
- Design : pixel art 2D vu du dessus  
- Builder style trackmania (construction modulaire et rapide)  

### Mécaniques principales  
- Convertir science en budget  
- Jauge écologique  
- Niveau de bien-être des scientifiques  
  - 0 = death  
  - 1 = ultra productif  
  - Démarrage à 0.3  
- Chemins dans la neige  
  - Pas de chemin = scientifique perdu et mort  

### Rôle des scientifiques  
- Début : généralistes (pas de spécialisation)  
- Progression : spécialisation (médecine, géologie, kebaberie, etc.)  

### Projets de recherche  
- Chaque projet = taux de risque  
  - Plus de risque = plus de récompenses, mais plus de chance de flop  
- **Jauge de risques** :  
  - Chaque lancement de projet = probabilité d’échec qui fait baisser le moral  
- Tableau des projets en cours :  
  - Affiché sur le côté droit de la zone de jeu (déroulant)  

### Bien-être  
- Animaux de compagnie  
  - Un peu = boost  
  - Trop = chaos  
- Santé = influence sur bien-être et productivité  
- Jauge de bien-être :  
  - Influence sur l’efficacité des projets  
  - Influence sur le niveau de risques  

### Ressources  
- Science  
- Confiance de l’État  

### Jauges principales  
- **Science**  
  - Affichée en haut à gauche  
  - Production dépend des projets actifs  
  - Arbre de progression : débloque de nouveaux bâtiments ou augmente les limites  
- **Bien-être**  
- **Productivité**  
  - Nombre d’unités de science produites par jour  
- **Écologie**  
  - Respect de la zone  
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
- **Interaction bâtiments** :  
  - Cliquer sur un bâtiment = zoom  
  - Ouverture d’un menu à droite  
  - Interface de création intérieure du bâtiment (choisir ce qu’on installe à l’intérieur)  
  - Visualisation en temps réel de ce qui se passe dans le bâtiment  
  - Filtre noir pour assombrir le reste de la zone (focus sur le bâtiment)  
