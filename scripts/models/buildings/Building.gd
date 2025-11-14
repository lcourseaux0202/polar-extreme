extends  Area2D
class_name Building

# infos
@export var id: int
@export var building_name: String
@export var building_description: String

@export var projets = []



func get_id():
	return id

func get_building_name():
	return building_name
	
func get_building_type() -> Enums.BUILDING_TYPE:
	return Enums.BUILDING_TYPE.NULL
