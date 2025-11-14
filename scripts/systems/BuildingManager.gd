extends Node
class_name BuildingManager

var building_factory = load("res://scripts/factories/BuildingFactory.gd").new()
var path_factory = load("res://scripts/factories/PathFactory.gd").new()

var building_counter := 0

var buildings_positions = {
	Enums.BUILDING_TYPE.TOILET: [],
	Enums.BUILDING_TYPE.DORMITORY: [],
	Enums.BUILDING_TYPE.CANTEEN: [],
	Enums.BUILDING_TYPE.LABO: [],
	Enums.BUILDING_TYPE.SHOWER: []
}

func create_building(bname : Enums.BUILDING_NAME) -> Building:
	var building : Building = building_factory.create_building(bname)
	building.name = "Building#" + str(building_counter)
	return building

func create_path() -> Path:
	var path = path_factory.create_path()
	return path

func register(building : Building):
	building_counter += 1
	
	var type = building.get_building_type()
	buildings_positions[type].append(building.global_position)
