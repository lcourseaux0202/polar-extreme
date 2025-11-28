extends Node
class_name BuildingManager

var building_factory = load("res://scripts/factories/BuildingFactory.gd").new()
var path_factory = load("res://scripts/factories/PathFactory.gd").new()
var buildingsIds := {}

var building_counter := 0
var hovered_building : Building = null

var buildings_positions = {
	Enums.BUILDING_TYPE.LABORATORY_GLACIOLOGY: [],
	Enums.BUILDING_TYPE.LABORATORY_ATMOSPHERIC_PHYSICS: [],
	Enums.BUILDING_TYPE.LABORATORY_MAGNETISM_SEISMOLOGY: [],
	Enums.BUILDING_TYPE.LABORATORY_HUMAN_BIOLOGY: [],
	Enums.BUILDING_TYPE.ICEMINE: [],
	Enums.BUILDING_TYPE.GREENHOUSE: [],
	Enums.BUILDING_TYPE.DORMITORY: [],
	Enums.BUILDING_TYPE.CANTEEN: [],
	Enums.BUILDING_TYPE.SHOWER: [],
	Enums.BUILDING_TYPE.TOILET: [],
	Enums.BUILDING_TYPE.LOUNGE : [],
	Enums.BUILDING_TYPE.GYM : [],
	Enums.BUILDING_TYPE.WASTE_SORTING : [],
	Enums.BUILDING_TYPE.WATER_RECYCLING : [],
	Enums.BUILDING_TYPE.POWER_PLANT : [],
	Enums.BUILDING_TYPE.NONE : []
}

var buildings_positions_no_group := []

func create_building(btype : Enums.BUILDING_TYPE) -> Building:
	var building : Building = building_factory.create_building(btype)
	building.name = "Building#" + str(building_counter)
	
	var plist = GameController.get_projects_manager().get_list(btype, building)
	if plist and building.has_method("set_projects"):
		building.set_projects(plist)
		print("ajoute la liste")
		print(str(btype) + building.name)
		print("\n")
		
	return building

func create_path() -> Path:
	var path = path_factory.create_path()
	return path

func register(building : Building):
	building_counter += 1
	var type = building.get_building_type()
	buildings_positions[type].append(building.global_position)
	buildings_positions[type].append(building.get_door_position())
	buildings_positions_no_group.append(building.get_door_position())

func unregister(building:Building):
	var type = building.get_building_type()
	buildings_positions[type].erase(building)
	
func get_building(id :int) -> Building:
	return buildingsIds[id]

func get_random_building_position() -> Vector2:
	if buildings_positions_no_group.size() != 0:
		return buildings_positions_no_group.pick_random()
	else :
		return Vector2(0,0)
