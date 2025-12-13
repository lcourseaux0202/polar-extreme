extends Node2D

@onready var world_manager : WorldManager = load("res://scripts/systems/WorldManager.gd").new()
@onready var scientist_manager : ScientistManager = load("res://scripts/systems/ScientistManager.gd").new()
@onready var time_manager : TimeManager = load("res://scripts/systems/TimeManager.gd").new()
@onready var building_manager : BuildingManager = load("res://scripts/systems/BuildingManager.gd").new()
@onready var gauges : Gauges = load("res://scripts/models/game/Gauges.gd").new()
@onready var projects_manager : ProjectsManager = load("res://scripts/models/projects/ProjectsManager.gd").new()
@onready var game_started := false


func _ready():
	pass

func _process(delta) -> void :
	if game_started :
		time_manager.process_time(delta)

func set_grid(grid : TileMapLayer):
	game_started = true
	world_manager.world_grid = grid
	UiController.build_batiment.connect(_on_build_batiment)
	UiController.enroll_scientist.connect(_on_enroll_scientist)
	UiController.validate_building_placement.connect(_on_validate_building_placement)
	UiController.delete_building.connect(_on_delete_building)
	UiController.assign_scientist.connect(_on_assign_scientist)
	UiController.deassign_scientist.connect(_on_deassign_scientist)

func _on_build_batiment(bname:Enums.BUILDING_TYPE):
	var building := building_manager.create_building(bname)
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
	
	
func _on_assign_scientist() :
	scientist_manager.assign_scientist()
	UiController.emit_update_assign_scientist()
	
func _on_deassign_scientist() :
	scientist_manager.deassign_scientist()
	UiController.emit_update_deassign_scientist()

func enough_scientist_for_assignement(n_scientist : int) -> bool :
	return scientist_manager.enough_scientist_for_assignement(n_scientist) 
	
func get_scientist_total() -> int :
	return scientist_manager.get_scientist_total()
	
func get_scientist_occupied() -> int :
	return scientist_manager.get_scientist_occupied()


	
func get_gauges() -> Gauges:
	return gauges
	
func get_building_manager() -> BuildingManager:
	return building_manager

func get_projects_manager() -> ProjectsManager:
	return projects_manager

func notify_scientist_new_hour(hour : int):
	UiController.emit_new_hour(hour)

func get_random_building_position() -> Vector2:
	return building_manager.get_random_building_position()
	
func get_all_buildings() -> Array[Building] :
	if building_manager:
		return building_manager.buildings_list
	else :
		return []

func zoom_camera(building : Building):
	UiController.emit_zoom_building(building.global_position)
	
func get_building_description(btype : Enums.BUILDING_TYPE) -> String :
	return building_manager.get_building_description(btype)
