extends Node
class_name BuildingFactory

const BUILDING_DATA := {
	# === RECHERCHE ===
	Enums.BUILDING_NAME.LAB_GLACIOLOGY: {
		"category": "Recherche",
		"name": "Laboratoire de glaciologie",
		"scene_path": "res://scenes/buildings/LabGlaciology.tscn",
	},
	Enums.BUILDING_NAME.LAB_ATMOSPHERIC_PHYSICS: {
		"category": "Recherche",
		"name": "Laboratoire de physique de l'atmosphère",
		"scene_path": "res://scenes/buildings/LabAtmosphere.tscn",
	},
	Enums.BUILDING_NAME.LAB_MAGNETISM_SEISMOLOGY: {
		"category": "Recherche",
		"name": "Laboratoire de magnétisme & sismologie",
		"scene_path": "res://scenes/buildings/LabMagnetism.tscn",
	},
	Enums.BUILDING_NAME.LAB_BIOLOGY: {
		"category": "Recherche",
		"name": "Laboratoire de biologie humaine",
		"scene_path": "res://scenes/buildings/LabBiology.tscn",
	},
	Enums.BUILDING_NAME.ICE_MINE: {
		"category": "Recherche",
		"name": "Mine de glace",
		"scene_path": "res://scenes/buildings/instanciables/IceMine.tscn",
	},
	Enums.BUILDING_NAME.GREENHOUSE: {
		"category": "Recherche",
		"name": "Serre",
		"scene_path": "res://scenes/buildings/Greenhouse.tscn",
	},

	# === VIE QUOTIDIENNE ===
	Enums.BUILDING_NAME.DORMITORIES: {
		"category": "Vie quotidienne",
		"name": "Chambres",
		"scene_path": "res://scenes/buildings/Dormitories.tscn",
	},
	Enums.BUILDING_NAME.KITCHEN: {
		"category": "Vie quotidienne",
		"name": "Cuisines",
		"scene_path": "res://scenes/buildings/Kitchen.tscn",
	},
	Enums.BUILDING_NAME.DINING_HALL: {
		"category": "Vie quotidienne",
		"name": "Salle à manger",
		"scene_path": "res://scenes/buildings/DiningHall.tscn",
	},
	Enums.BUILDING_NAME.TOILETS: {
		"category": "Vie quotidienne",
		"name": "Toilettes",
		"scene_path": "res://scenes/buildings/Toilets.tscn",
	},
	Enums.BUILDING_NAME.SHOWERS: {
		"category": "Vie quotidienne",
		"name": "Douches",
		"scene_path": "res://scenes/buildings/Showers.tscn",
	},
	Enums.BUILDING_NAME.LOUNGE: {
		"category": "Vie quotidienne",
		"name": "Salle de repos",
		"scene_path": "res://scenes/buildings/Lounge.tscn",
	},
	Enums.BUILDING_NAME.GYM: {
		"category": "Vie quotidienne",
		"name": "Salle de sport",
		"scene_path": "res://scenes/buildings/Gym.tscn",
	},

	# === TECHNIQUE ===
	Enums.BUILDING_NAME.WASTE_SORTING: {
		"category": "Technique",
		"name": "Tri des déchets",
		"scene_path": "res://scenes/buildings/WasteSorting.tscn",
	},
	Enums.BUILDING_NAME.WATER_RECYCLING: {
		"category": "Technique",
		"name": "Recyclage de l'eau",
		"scene_path": "res://scenes/buildings/WaterRecycling.tscn",
	},
	Enums.BUILDING_NAME.POWER_PLANT: {
		"category": "Technique",
		"name": "Centrale électrique",
		"scene_path": "res://scenes/buildings/PowerPlant.tscn",
	},
}

func create_building(bname : Enums.BUILDING_NAME):
	var data = BUILDING_DATA[bname]
	var scene = load(data["scene_path"]).instantiate()
	return scene

func get_preview_texture():
	pass
