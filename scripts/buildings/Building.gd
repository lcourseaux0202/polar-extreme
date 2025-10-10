class_name Building
extends Resource

enum BUILDING_TYPE { SCIENCE, UTILITY }

# infos
@export var id: int
@export var building_name: String
@export var building_description: String

# visual
@export var sprite: Texture2D

# location
@export var size: Vector2 		# from the the upper left tile of the building, starting at 0,0
@export var building_position: Vector2

@export var projets = []

func constructs(pos: Vector2):
	id = BuildingIdManager.register(self)
	building_position = pos # upper left tile of the building

func destroy():
	BuildingIdManager.remove(id)

func get_id():
	return id

func get_building_name():
	return building_name
