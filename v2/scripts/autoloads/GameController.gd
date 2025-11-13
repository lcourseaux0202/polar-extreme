extends Node2D

@onready var world_manager : WorldManager = load("res://v2/scripts/systems/WorldManager.gd").new()
@onready var scientist_manager : ScientistManager = load("res://v2/scripts/systems/ScientistManager.gd").new()
@onready var time_manager : TimeManager = load("res://v2/scripts/systems/TimeManager.gd").new()
@onready var building_manager : BuildingManager = load("res://v2/scripts/systems/BuildingManager.gd").new()

func _ready():
	pass

func set_grid(grid : TileMapLayer):
	world_manager.world_grid = grid
	UIController.build_batiment.connect(_on_build_batiment)
	UIController.build_path.connect(_on_build_path)
	UIController.validate_building_placement.connect(_on_validate_building_placement)
	
func _on_build_batiment():
	var building = building_manager.create_building(Enums.BUILDING_NAME.ICE_MINE)
	var position = Vector2(50,50)
	world_manager.place_building(building)
	building_manager.register(building)
	
func _on_validate_building_placement():
	get_global_mouse_position()
	
func _on_build_path():
	var path = building_manager.create_path()
	var position = Vector2(50,50)
	world_manager.place_path(path)
	
