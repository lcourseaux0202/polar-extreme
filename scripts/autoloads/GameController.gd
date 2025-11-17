extends Node2D

@onready var world_manager : WorldManager = load("res://scripts/systems/WorldManager.gd").new()
@onready var scientist_manager : ScientistManager = load("res://scripts/systems/ScientistManager.gd").new()
@onready var time_manager : TimeManager = load("res://scripts/systems/TimeManager.gd").new()
@onready var building_manager : BuildingManager = load("res://scripts/systems/BuildingManager.gd").new()
@onready var gauges : Gauges = load("res://scripts/models/game/Gauges.gd").new()

func _ready():
	pass

func set_grid(grid : TileMapLayer):
	world_manager.world_grid = grid
	UiController.build_batiment.connect(_on_build_batiment)
	UiController.enroll_scientist.connect(_on_enroll_scientist)
	UiController.validate_building_placement.connect(_on_validate_building_placement)
	UiController.delete_building.connect(_on_delete_building)

func _on_build_batiment(bname:Enums.BUILDING_TYPE):
	var building := building_manager.create_building(Enums.BUILDING_TYPE.ICEMINE)
	UiController.emit_start_building(building)

func _on_build_path():
	UiController.emit_start_building_path()

func _on_validate_building_placement(building:Building):
	building_manager.register(building)
	world_manager.place_building(building)

func _on_delete_building(building:Building):
	building_manager.unregister(building)

func _on_enroll_scientist():
	var scientist_to_place : Scientist = scientist_manager.enroll_scientist()
	world_manager.place_scientist(scientist_to_place)
	
func get_gauges() -> Gauges:
	return gauges
	
func get_building_manager() -> BuildingManager:
	return building_manager
