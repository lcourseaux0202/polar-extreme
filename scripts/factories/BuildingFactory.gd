extends Node
class_name BuildingFactory

const BUILDING_DATA := {
	# === RECHERCHE ===
	Enums.BUILDING_TYPE.LABORATORY_GLACIOLOGY: {
		"category": "Recherche",
		"name": "Laboratoire de glaciologie",
		"scene_path": "res://scenes/buildings/instanciables/Glaciology.tscn",
	},
	Enums.BUILDING_TYPE.LABORATORY_ATMOSPHERIC_PHYSICS: {
		"category": "Recherche",
		"name": "Laboratoire de physique de l'atmosphère",
		"scene_path": "res://scenes/buildings/instanciables/LabAtmosphere.tscn",
	},
	Enums.BUILDING_TYPE.LABORATORY_MAGNETISM_SEISMOLOGY: {
		"category": "Recherche",
		"name": "Laboratoire de magnétisme & sismologie",
		"scene_path": "res://scenes/buildings/instanciables/LabMagnetism.tscn",
	},
	Enums.BUILDING_TYPE.LABORATORY_HUMAN_BIOLOGY: {
		"category": "Recherche",
		"name": "Laboratoire de biologie humaine",
		"scene_path": "res://scenes/buildings/instanciables/LabBiology.tscn",
	},
	Enums.BUILDING_TYPE.ICEMINE: {
		"category": "Recherche",
		"name": "Mine de glace",
		"scene_path": "res://scenes/buildings/instanciables/IceMine.tscn",
	},
	Enums.BUILDING_TYPE.GREENHOUSE: {
		"category": "Recherche",
		"name": "Serre",
		"scene_path": "res://scenes/buildings/instanciables/Greenhouse.tscn",
	},

	# === VIE QUOTIDIENNE ===
	Enums.BUILDING_TYPE.DORMITORY: {
		"category": "Vie quotidienne",
		"name": "Chambres",
		"scene_path": "res://scenes/buildings/Dormitories.tscn",
	},
	Enums.BUILDING_TYPE.CANTEEN: {
		"category": "Vie quotidienne",
		"name": "Cantine",
		"scene_path": "res://scenes/buildings/Canteen.tscn",
	},

	Enums.BUILDING_TYPE.TOILET: {
		"category": "Vie quotidienne",
		"name": "Toilettes",
		"scene_path": "res://scenes/buildings/Toilets.tscn",
	},
	Enums.BUILDING_TYPE.SHOWER: {
		"category": "Vie quotidienne",
		"name": "Douches",
		"scene_path": "res://scenes/buildings/Showers.tscn",
	},
	Enums.BUILDING_TYPE.LOUNGE: {
		"category": "Vie quotidienne",
		"name": "Salle de repos",
		"scene_path": "res://scenes/buildings/Lounge.tscn",
	},
	Enums.BUILDING_TYPE.GYM: {
		"category": "Vie quotidienne",
		"name": "Salle de sport",
		"scene_path": "res://scenes/buildings/Gym.tscn",
	},

	# === TECHNIQUE ===
	Enums.BUILDING_TYPE.WASTE_SORTING: {
		"category": "Technique",
		"name": "Tri des déchets",
		"scene_path": "res://scenes/buildings/WasteSorting.tscn",
	},
	Enums.BUILDING_TYPE.WATER_RECYCLING: {
		"category": "Technique",
		"name": "Recyclage de l'eau",
		"scene_path": "res://scenes/buildings/WaterRecycling.tscn",
	},
	Enums.BUILDING_TYPE.POWER_PLANT: {
		"category": "Technique",
		"name": "Centrale électrique",
		"scene_path": "res://scenes/buildings/PowerPlant.tscn",
	},
}

func create_building(btype : Enums.BUILDING_TYPE):
	var data = BUILDING_DATA[btype]
	var scene = load(data["scene_path"]).instantiate()
	return scene

func get_preview_texture():
	pass
