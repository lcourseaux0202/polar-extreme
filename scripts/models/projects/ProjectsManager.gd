class_name ProjectsManager
extends Node

# --- Laboratoire de glaciologie ---
var list_glaciology: Array[Project] = [
	Project.new(0, "Analyse des carottes de glace", 40, 0, 0, 3, 0),
	Project.new(1, "Préservation d’échantillons cryogéniques", 30, 0, 0, 2, 0),
	Project.new(2, "Modélisation des archives climatiques", 60, 0, 0, 5, 0),
	Project.new(3, "Prédiction de fonte glaciaire", 80, 0, 0, 6, 0)
]

# --- Laboratoire de physique de l’atmosphère ---
var list_atmospheric: Array[Project] = [
	Project.new(0, "Microphysique des nuages", 50, 0, 0, 4, 0),
	Project.new(1, "Dynamique des aérosols", 40, 0, 0, 3, 0),
	Project.new(2, "Modèle d’équilibre radiatif", 70, 0, 0, 5, 0),
	Project.new(3, "Système de surveillance de l’ozone", 60, 0, 0, 4, 0)
]

# --- Laboratoire de magnétisme et sismologie ---
var list_magnetism: Array[Project] = [
	Project.new(0, "Cartographie du champ magnétique", 40, 0, 0, 2, 0),
	Project.new(1, "Analyse de l’activité sismique", 50, 0, 0, 3, 0),
	Project.new(2, "Modélisation tectonique", 60, 0, 0, 4, 0),
	Project.new(3, "Simulation du magnétisme du noyau", 80, 0, 0, 5, 0)
]

# --- Laboratoire de biologie humaine ---
var list_biology: Array[Project] = [
	Project.new(0, "Étude d’adaptation au froid", 30, 0, 0, 1, 0),
	Project.new(1, "Cartographie de la réponse immunitaire", 40, 0, 0, 2, 0),
	Project.new(2, "Test de fatigue neuronale", 50, 0, 0, 3, 0),
	Project.new(3, "Optimisation biothermique", 60, 0, 0, 3, 0)
]

# --- Mine de glace ---
var list_icemine: Array[Project] = [
	Project.new(0, "Forage profond", 0, 40, 0, 3, 1),
	Project.new(1, "Automatisation de l’extraction", 0, 60, 0, 5, 1),
	Project.new(2, "Amélioration du forage thermique", 0, 70, 0, 6, 2),
	Project.new(3, "Optimisation du raffinage", 0, 80, 0, 7, 2)
]

# --- Serre ---
var list_greenhouse: Array[Project] = [
	Project.new(0, "Régénération des sols", 0, 30, 0, -3, 0),
	Project.new(1, "Amélioration du rendement", 0, 50, 0, -4, 0),
	Project.new(2, "Efficacité photosynthétique", 0, 60, 0, -5, 0),
	Project.new(3, "Filtration de la pollution", 0, 40, 0, -6, -1)
]

# --- Récupération de la liste associée au batiment
func get_list(type: Enums.BUILDING_TYPE, id: int) -> Array[Project]:
	var source: Array[Project]
	
	match type:
		Enums.BUILDING_TYPE.LABORATORY_GLACIOLOGY:
			source = list_glaciology
		Enums.BUILDING_TYPE.LABORATORY_ATMOSPHERIC_PHYSICS:
			source = list_atmospheric
		Enums.BUILDING_TYPE.LABORATORY_MAGNETISM_SEISMOLOGY:
			source = list_magnetism
		Enums.BUILDING_TYPE.LABORATORY_HUMAN_BIOLOGY:
			source = list_biology
		Enums.BUILDING_TYPE.ICEMINE:
			source = list_icemine
		Enums.BUILDING_TYPE.GREENHOUSE:
			source = list_greenhouse
		_:
			source = []
		
	var new_list: Array[Project]
	for example_project: Project in source:
		var new_project := example_project.duplicate()
		new_project.set_building_id(id)
		new_list.append(new_project)
		
	return new_list
