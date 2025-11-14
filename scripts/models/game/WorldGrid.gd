extends TileMapLayer
class_name WorldGrid

@onready var scientist_spawn_position: Marker2D = $ScientistSpawnPosition
var buildings_doors_positions = {
	Enums.BUILDING_TYPE.LABO : [],
	Enums.BUILDING_TYPE.DORMITORY : [],
	Enums.BUILDING_TYPE.CANTEEN : [],
	Enums.BUILDING_TYPE.SHOWER : [],
	Enums.BUILDING_TYPE.TOILET : []
}

func register_door_position(building : Building):
	buildings_doors_positions[building.type].append(building.global_position)

func get_scientist_spawn_position() -> Vector2:
	return scientist_spawn_position.global_position
