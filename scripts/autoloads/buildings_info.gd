extends Node

var buildingsPositions = {
	Enums.BUILDING_TYPE.TOILET : [],
	Enums.BUILDING_TYPE.DORMITORY : [],
	Enums.BUILDING_TYPE.CANTEEN : [],
	Enums.BUILDING_TYPE.LABO : [],
	Enums.BUILDING_TYPE.SHOWER : []
}

func add_building(building : Building) -> void:
	buildingsPositions[building.get_building_type()] = building.global_position

func get_closest_building(building_type : Enums.BUILDING_TYPE, npc_position : Vector2) -> Vector2:
	var closest_position : Vector2 = buildingsPositions[building_type]
	for position : Vector2 in buildingsPositions[building_type]:
		if(position.distance_to(npc_position) < closest_position.distance_to(npc_position)):
			closest_position = position
	return closest_position
