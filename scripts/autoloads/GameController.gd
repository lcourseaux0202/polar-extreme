extends Node2D

@onready var world_manager : WorldManager = load("res://scripts/systems/WorldManager.gd").new()
@onready var scientist_manager : ScientistManager = load("res://scripts/systems/ScientistManager.gd").new()
@onready var time_manager : TimeManager = load("res://scripts/systems/TimeManager.gd").new()
@onready var building_manager : BuildingManager = load("res://scripts/systems/BuildingManager.gd").new()

func _ready():
	pass

func set_grid(grid : TileMapLayer):
	world_manager.world_grid = grid
	UiController.build_batiment.connect(_on_build_batiment)
	UiController.validate_building_placement.connect(_on_validate_building_placement)
	
func _on_build_batiment(bname:Enums.BUILDING_NAME):
	var building := building_manager.create_building(Enums.BUILDING_NAME.ICE_MINE)
	UiController.emit_start_building(building)
	
func _on_build_path():
	UiController.emit_start_building_path()	
	

	
func _on_validate_building_placement(building:Building):
	building_manager.register(building)

	
func _on_validate_path_placement(path:Path):
	print("pass")

	
	
