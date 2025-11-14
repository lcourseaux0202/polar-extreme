extends  Area2D
class_name Building

# infos
@export var id: int
@export var building_name: String
@export var building_description: String
@export var building_genre : Enums.BUILDING_GENRE
@export var building_type: Enums.BUILDING_TYPE
@export var pollution_per_second: float



func get_id():
	return id

func get_building_name():
	return building_name
	
func get_building_type() -> Enums.BUILDING_TYPE:
	return Enums.BUILDING_TYPE.NONE

func get_pollution() -> float:
	return pollution_per_second
	
func change_pollution(value: float) -> void:
	pollution_per_second += value
	Gauges.change_pollution_per_second(value)
