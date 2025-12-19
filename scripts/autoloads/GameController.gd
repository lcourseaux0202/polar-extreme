extends Node2D
## Main game controller that coordinates all game systems.
##
## This singleton-style controller manages all major game systems including world management,
## scientist management, time tracking, building placement, and resource gauges. Acts as the
## central hub connecting UI events to game logic through the UiController signal system.
## Uses a composition pattern with multiple manager instances to separate concerns.

@onready var world_manager: WorldManager = load("res://scripts/systems/WorldManager.gd").new()
@onready var scientist_manager: ScientistManager = load("res://scripts/systems/ScientistManager.gd").new()
@onready var time_manager: TimeManager = load("res://scripts/systems/TimeManager.gd").new()
@onready var building_manager: BuildingManager = load("res://scripts/systems/BuildingManager.gd").new()
@onready var gauges: Gauges = load("res://scripts/models/game/Gauges.gd").new()
@onready var projects_manager: ProjectsManager = load("res://scripts/models/projects/ProjectsManager.gd").new()

## Starting amount of science points for a new game
const START_SCIENCE: int = 500

## Tracks whether the game has been initialized and started
var game_started: bool = false

## Update interval in seconds for gauge calculations
var update_time: float = 0.1


func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = update_time
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_update_gauges)


## Processes time progression when the game is active.
## [param delta] Time elapsed since the previous frame
func _process(delta: float) -> void:
	if game_started:
		time_manager.process_time(delta)


## Initializes the game world and connects all UI signals.
## Sets up the world grid where buildings will be placed and starts the game.
## [param grid] TileMapLayer used as the world grid for building placement
func set_grid(grid: TileMapLayer) -> void:
	game_started = true
	world_manager.world_grid = grid
	UiController.build_batiment.connect(_on_build_batiment)
	UiController.enroll_scientist.connect(_on_enroll_scientist)
	UiController.validate_building_placement.connect(_on_validate_building_placement)
	UiController.delete_building.connect(_on_delete_building)
	UiController.assign_scientist.connect(_on_assign_scientist)
	UiController.deassign_scientist.connect(_on_deassign_scientist)
	
	gauges.change_science(START_SCIENCE)
	gauges.set_pollution_per_second(0)


## Signal handler for building construction requests.
## Creates a building instance and triggers placement mode in the UI.
## [param bname] Type of building to construct from Enums.BUILDING_TYPE
func _on_build_batiment(bname: Enums.BUILDING_TYPE) -> void:
	var building := building_manager.create_building(bname)
	UiController.emit_start_building(building)


## Signal handler for path building requests.
## Triggers path placement mode in the UI.
func _on_build_path() -> void:
	UiController.emit_start_building_path()


## Signal handler for confirmed building placement.
## Registers the building, places it in the world, and deducts its cost.
## [param building] The building instance to place in the game world
func _on_validate_building_placement(building: Building) -> void:
	building_manager.register(building)
	world_manager.place_building(building)
	gauges.change_science(-building.price)
	GameController.gauges.change_wellness(building.wellness_value)


## Signal handler for building deletion.
## Unregisters the building from the manager.
## [param building] The building instance to remove
func _on_delete_building(building: Building) -> void:
	building_manager.unregister(building)


## Signal handler for scientist enrollment.
## Creates a new scientist and places them in the world.
func _on_enroll_scientist() -> void:
	var scientist_to_place: Scientist = scientist_manager.enroll_scientist()
	world_manager.place_scientist(scientist_to_place)


## Signal handler for scientist assignment to a building.
## Updates the scientist counter and notifies UI.
func _on_assign_scientist() -> void:
	scientist_manager.assign_scientist()
	UiController.emit_update_assign_scientist()


## Signal handler for scientist removal from a building.
## Updates the scientist counter and notifies UI.
func _on_deassign_scientist() -> void:
	scientist_manager.deassign_scientist()
	UiController.emit_update_deassign_scientist()


## Checks if enough unassigned scientists are available.
## [param n_scientist] Number of scientists needed
## [return] True if enough idle scientists exist, False otherwise
func enough_scientist_for_assignement(n_scientist: int) -> bool:
	return scientist_manager.enough_scientist_for_assignement(n_scientist)


## Gets the total number of enrolled scientists.
## [return] Total scientist count
func get_scientist_total() -> int:
	return scientist_manager.get_scientist_total()


## Gets the number of scientists currently assigned to buildings.
## [return] Number of occupied scientists
func get_scientist_occupied() -> int:
	return scientist_manager.get_scientist_occupied()


## Gets the resource gauges manager.
## [return] Gauges instance managing science, pollution, and wellness
func get_gauges() -> Gauges:
	return gauges


## Gets the building manager.
## [return] BuildingManager instance handling all buildings
func get_building_manager() -> BuildingManager:
	return building_manager


## Gets the projects manager.
## [return] ProjectsManager instance handling research projects
func get_projects_manager() -> ProjectsManager:
	return projects_manager


## Notifies all scientists of a new in-game hour.
## [param hour] The current in-game hour
func notify_scientist_new_hour(hour: int) -> void:
	UiController.emit_new_hour(hour)


## Gets a random building's door position for scientist navigation.
## [return] Global position Vector2 of a random building's door
func get_random_building_position() -> Vector2:
	return building_manager.get_random_building_position()


## Gets the list of all buildings currently in the game.
## [return] Array of all Building instances
func get_all_buildings() -> Array[Building]:
	if building_manager:
		return building_manager.buildings_list
	else:
		return []


## Triggers a camera zoom to focus on a specific building.
## [param building] The building to focus the camera on
func zoom_camera(building: Building) -> void:
	UiController.emit_zoom_building(building.global_position)


## Gets the description text for a building type.
## [param btype] The building type to get description for
## [return] Description string for the building
func get_building_description(btype: Enums.BUILDING_TYPE) -> String:
	return building_manager.get_building_description(btype)


## Updates all resource gauges (called periodically by timer).
func _update_gauges() -> void:
	gauges.update_gauges()


## Attempts to hire a new scientist if resources are available.
## Deducts cost and adds pollution if successful.
## [return] 0 if successful, 1 if insufficient science, 2 if no building space
func pay_scientist() -> int:
	if gauges.science >= scientist_manager.get_scientist_price():
		if building_manager.get_free_spaces() > scientist_manager.scientist_total:
			gauges.change_science(-scientist_manager.get_scientist_price())
			gauges.change_pollution(scientist_manager.get_scientist_pollution_travel())
			gauges.change_pollution_per_second(scientist_manager.get_scientist_pollution_per_second())
			scientist_manager.increase_price()
			return 0
		else:
			return 2
	else:
		return 1


## Initializes the game with default starting buildings and a scientist.
## Places a dormitory and laboratory on the map and enrolls one scientist.
## [param world_grid] The TileMapLayer grid to place buildings on
func init_default(world_grid: TileMapLayer) -> void:
	var defaultBedRoom = building_manager.create_building(Enums.BUILDING_TYPE.DORMITORY)
	var mouse_pos_glob: Vector2 = Vector2(1000, 480)
	var mouse_pos_grid: Vector2 = to_local(mouse_pos_glob)
	var tile_under_mouse: Vector2i = world_grid.local_to_map(mouse_pos_grid)
	var world_grid_pos: Vector2 = world_grid.map_to_local(tile_under_mouse)
	defaultBedRoom.position = world_grid_pos
	UiController.emit_validate_building_placement(defaultBedRoom)
	
	var defaultScience = building_manager.create_building(Enums.BUILDING_TYPE.LABORATORY_GLACIOLOGY)
	mouse_pos_glob = Vector2(850, 520)
	mouse_pos_grid = to_local(mouse_pos_glob)
	tile_under_mouse = world_grid.local_to_map(mouse_pos_grid)
	world_grid_pos = world_grid.map_to_local(tile_under_mouse)
	defaultScience.position = world_grid_pos
	UiController.emit_validate_building_placement(defaultScience)
	
	UiController.emit_enroll_scientist()
