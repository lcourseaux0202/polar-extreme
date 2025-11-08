class_name Building
extends  Area2D

# infos
@export var id: int
@export var building_name: String
@export var building_description: String

@export var projets = []

func _init():
	id = BuildingIdManager.register(self)

func destroy():
	BuildingIdManager.remove(id)

func get_id():
	return id

func get_building_name():
	return building_name
	
func get_building_type() -> Enums.BUILDING_TYPE:
	return Enums.BUILDING_TYPE.NULL
