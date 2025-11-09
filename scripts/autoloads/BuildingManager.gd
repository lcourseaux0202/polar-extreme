class_name BuildingManager
extends Node

static var _next_id := 1
static var _buildingsIds := {}

var _buildingsPositions = {
	Enums.BUILDING_TYPE.TOILET: [],
	Enums.BUILDING_TYPE.DORMITORY: [],
	Enums.BUILDING_TYPE.CANTEEN: [],
	Enums.BUILDING_TYPE.LABO: [],
	Enums.BUILDING_TYPE.SHOWER: []
}

var buildings_scenes = {
	"IceMine" : preload("res://scenes/buildings/instanciables/IceMine.tscn"),
	"Shower" : preload("res://scenes/buildings/instanciables/ShowerBlock.tscn"),
	"Toilet" : preload("res://scenes/buildings/instanciables/Toilet.tscn")
}

func instantiate_building(building : String) -> Building :
	if buildings_scenes.has(building):
		return buildings_scenes[building].instantiate()
	else :
		return null

func add_building(building: Building) -> void:
	var btype = building.get_building_type()
	if not _buildingsPositions.has(btype):
		_buildingsPositions[btype] = []
	_buildingsPositions[btype].append(building.global_position) 
	
static func register(new_building: Building):
	var id = _next_id
	_next_id += 1
	_buildingsIds[id] = new_building
	return id
	
static func remove(id: int):
	_buildingsIds.erase(id)

func get_closest_building(building_type : Enums.BUILDING_TYPE, npc_position : Vector2) -> Vector2:
	var closest_position : Vector2 = _buildingsPositions[building_type]
	for position : Vector2 in _buildingsPositions[building_type]:
		if(position.distance_to(npc_position) < closest_position.distance_to(npc_position)):
			closest_position = position
	return closest_position
	
static func get_building(id: int):
	return _buildingsIds[id]
