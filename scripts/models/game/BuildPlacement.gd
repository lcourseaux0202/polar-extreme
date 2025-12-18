extends TileMapLayer
class_name BuildPlacement
## Handles building and path placement on a tile-based grid.
##
## This class extends TileMapLayer to provide visual feedback and collision detection
## for placing buildings and paths. It uses the TileMapLayer's internal sparse dictionary
## structure (only stores occupied cells, not the entire grid) to efficiently display
## placement previews and validate positions before final placement.

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var preview: Sprite2D = $PreviewSprite
@onready var door: CollisionShape2D = $DoorPreview

@export var effect_size: Vector2 = Vector2(3, 3)

const IGNORED_LAYERS_FOR_BUILDING = [2]

## Indicates whether the system is in building placement mode
var in_placement: bool = false

## Indicates whether the system is in path placement mode
var in_path_placement: bool = false

## Indicates whether the current placement is valid (no collisions)
var can_be_placed: bool = true

## Reference to the building currently being placed
var building_data: Building

## Reference to the path currently being placed
var path_data: Path

## Indicates whether a placement animation is currently playing
var animation_playing: bool = false

## Counter for naming created paths
var n_path: int = 0

## Indicates whether object deletion mode is active
var in_delete_object: bool = false

## World position of the validated placement
var placement_position: Vector2

## Array of grid cells affected by the current placement
var cell_array: Array[Vector2i] = []

## Indicates whether the user is dragging to draw a path
var is_dragging_path: bool = false

## Starting position of the L-shaped path trace
var path_start_pos: Vector2i

## Array of cells previewed for the L-shaped path
var path_preview_cells: Array[Vector2i] = []

## Door offset from the building center
var door_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	UiController.start_building.connect(_on_building_signal)
	UiController.start_placing_path.connect(_on_path_button_pressed)
	UiController.start_delete_object.connect(delete_object)
	UiController.stop_building_path.connect(stop_building_path)


func _input(event: InputEvent) -> void:
	if animation_playing:
		return
	
	_update_mouse_positions()
	
	if in_placement:
		_handle_rotation_input()
		_handle_placement_preview(event)
		_handle_building_click(event)
	elif in_path_placement:
		_handle_path_drag_input(event)
		if not is_dragging_path:
			_handle_placement_preview(event)
	elif in_delete_object:
		_handle_delete_object(event)

## Signal handler to start or stop building placement.
## [param building] The building to place
func _on_building_signal(building: Building) -> void:
	if !in_placement:
		start_building(building)
	else:
		stop_building()


## Starts building placement mode.
## Configures the preview with the building's texture and data.
## [param building] The building to place
func start_building(building: Building) -> void:
	if animation_playing:
		return
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	in_placement = true
	building_data = building

	var sprite_node: Sprite2D = building.get_node_or_null("Sprite2D")
	if sprite_node:
		preview.texture = sprite_node.texture
	
	var door_node: CollisionShape2D = building.get_node_or_null("DoorCollision")
	if door_node:
		door.shape = door_node.shape
		door_offset = door_node.position

	var building_zone: CollisionShape2D = building.get_node_or_null("BuildingZone")
	if building_zone:
		effect_size = building_zone.shape.get_rect().size / 32


## Stops placement mode and resets all placement variables.
## Clears the preview.
func stop_building() -> void:
	in_placement = false
	in_path_placement = false
	building_data = null
	path_data = null
	preview.texture = null
	preview.rotation = 0
	is_dragging_path = false
	path_preview_cells.clear()
	cell_array.clear()
	self.clear()
	door_offset = Vector2.ZERO


## Updates the preview and door positions based on mouse position.
## Converts mouse position to grid coordinates.
func _update_mouse_positions() -> void:
	var mouse_pos_glob: Vector2 = get_global_mouse_position()
	var mouse_pos_grid: Vector2 = to_local(mouse_pos_glob)
	var tile_under_mouse: Vector2i = local_to_map(mouse_pos_grid)
	var world_grid_pos: Vector2 = map_to_local(tile_under_mouse)

	preview.position = world_grid_pos
	var rotated_offset = door_offset.rotated(preview.rotation)
	door.position = world_grid_pos + rotated_offset


## Handles preview rotation with the R key.
## Rotates the preview by 90° and swaps dimensions.
func _handle_rotation_input() -> void:
	if Input.is_key_pressed(KEY_R):
		preview.rotate(PI / 2)
		effect_size = Vector2(effect_size.y, effect_size.x)


## Displays the placement preview on the grid.
## Checks collisions and placement validity for each cell.
## [param event] The current input event
func _handle_placement_preview(event: InputEvent) -> void:
	if is_dragging_path:
		return
		
	_clear_previous_preview()
	can_be_placed = true

	var tile_under_mouse: Vector2i = local_to_map(to_local(get_global_mouse_position()))
	var size = effect_size.round()
	
	var start_x = -int(size.x / 2)
	var end_x = int(size.x / 2) + 1
	var start_y = -int(size.y / 2)
	var end_y = int(size.y / 2) + 1

	for i in range(start_x, end_x):
		for j in range(start_y, end_y):
			var pos: Vector2i = tile_under_mouse + Vector2i(i, j)
			cell_array.append(pos)
			var cell_world_pos: Vector2 = map_to_local(pos)
			
			var has_collision = _cell_collides(cell_world_pos)
			var is_adjacent_to_path = false
			if in_path_placement:
				is_adjacent_to_path = _is_adjacent_to_path(cell_world_pos)
			
			if in_path_placement:
				if has_collision or not is_adjacent_to_path:
					set_cell(pos, 0, Vector2i(1, 0))
					can_be_placed = false
				else:
					set_cell(pos, 0, Vector2i(2, 0))
			else:
				if has_collision:
					set_cell(pos, 0, Vector2i(1, 0))
					can_be_placed = false
				else:
					set_cell(pos, 0, Vector2i(2, 0))
	
	if in_placement and building_data != null:
		var door_ok = _door_touches_path(building_data, map_to_local(tile_under_mouse))
		if not door_ok:
			can_be_placed = false
			for cell_pos in cell_array:
				set_cell(cell_pos, 0, Vector2i(1, 0))


## Checks if the building's door touches a path.
## Uses a physics shape query to detect paths.
## [param building] The building whose door to check
## [param cell_world_pos] World position of the cell
## [return] True if the door touches a path, False otherwise
func _door_touches_path(building: Building, cell_world_pos: Vector2) -> bool:
	var shape = door.shape
	var shape_transform = Transform2D(building.global_rotation, building.global_position + door.position.rotated(building.global_rotation))

	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = shape_transform
	query.collide_with_areas = true
	query.collision_mask = 0xFFFFFFFF

	var result = get_world_2d().direct_space_state.intersect_shape(query, 8)

	for hit in result:
		if hit.collider is Path:
			return true

	return false


## Checks if a cell is adjacent to an existing path.
## Tests the 4 cardinal directions around the cell.
## [param cell_world_pos] World position of the cell to check
## [return] True if the cell is adjacent to a path, False otherwise
func _is_adjacent_to_path(cell_world_pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var tile_size = tile_set.tile_size
	var directions = [
		Vector2(-tile_size.x, 0), 
		Vector2(tile_size.x, 0),  
		Vector2(0, -tile_size.y), 
		Vector2(0, tile_size.y)  
	]
	
	for direction in directions:
		var check_pos = cell_world_pos + direction
		
		var query := PhysicsPointQueryParameters2D.new()
		query.position = check_pos
		query.collide_with_areas = true
		query.collision_mask = 0xFFFFFFFF
		
		var result = space_state.intersect_point(query, 8)
		
		for hit in result:
			if hit.collider is Path:
				return true
	
	return false


## Handles mouse clicks to validate or invalidate placement.
## Plays the appropriate animation depending on placement validity.
## [param event] The input event to process
func _handle_building_click(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == SettingsValue.Pos and event.pressed and can_be_placed:
		placement_position = preview.position
		animation_playing = true
		animation.play("placementAnimationLib/goodPlacement")
		_clear_previous_preview()
	if event is InputEventMouseButton and event.button_index == SettingsValue.Pos and event.pressed and not can_be_placed:
		animation.play("placementAnimationLib/invalidPlacement")


## Clears the previous grid preview.
## Resets all displayed cells and empties the array.
func _clear_previous_preview() -> void:
	for cell_pos in cell_array:
		set_cell(cell_pos, 0, Vector2i(0, 0))
	cell_array.clear()


## Placement animation end handler.
## Instantiates the building or path depending on the active mode.
## [param _anim_name] Name of the finished animation
func _handle_animation_end(_anim_name: StringName) -> void:
	if _anim_name == "placementAnimationLib/goodPlacement":
		animation_playing = false
		if in_placement:
			var instance: Building = building_data
			instance.rotation = preview.rotation
			instance.position = placement_position
			instance.name = instance.name + "_" + str(building_data.get_id())
			UiController.emit_validate_building_placement(instance)
			stop_building()
		elif in_path_placement:
			var instance: Path = path_data
			instance.position = placement_position
			instance.name = "Path" + str(n_path)
			n_path += 1
			%PathRegions.add_child(instance)
			UiController.emit_validate_building_path(instance)
			build_path()


## Checks if a cell collides with physical objects.
## Uses a RectangleShape2D to test for collisions.
## [param cell_world_pos] World position of the cell to check
## [return] True if the cell has a collision, False otherwise
func _cell_collides(cell_world_pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var cell_size = tile_set.tile_size

	var rect_shape = RectangleShape2D.new()
	rect_shape.size = cell_size

	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = rect_shape
	query.transform = Transform2D(0, cell_world_pos)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.exclude = [self]
	query.collision_mask = get_collision_layers_mask(IGNORED_LAYERS_FOR_BUILDING)
	
	var result = space_state.intersect_shape(query, 1)
	return result.size() > 0


## Checks if a path already exists at a given position.
## Uses a physics point query to detect paths.
## [param cell_world_pos] World position of the cell to check
## [return] True if a path exists at this position, False otherwise
func _cell_has_path(cell_world_pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	
	var query := PhysicsPointQueryParameters2D.new()
	query.position = cell_world_pos
	query.collide_with_areas = true
	query.collision_mask = 0xFFFFFFFF
	
	var result = space_state.intersect_point(query, 8)
	
	for hit in result:
		if hit.collider is Path:
			return true
	
	return false


## Calculates a collision mask excluding certain layers.
## [param ignored_layers] Array of layer indices to ignore (1-32)
## [return] Collision mask with ignored layers disabled
func get_collision_layers_mask(ignored_layers: Array) -> int:
	var collision_mask := 0xFFFFFFFF

	for layer_index in ignored_layers:
		if layer_index >= 1 and layer_index <= 32:
			collision_mask &= ~(1 << (layer_index - 1))
			
	return collision_mask


## Path placement button handler.
## Starts or stops path placement mode.
func _on_path_button_pressed() -> void:
	if in_path_placement:
		stop_building_path()
	else:
		start_building_path()


## Starts path placement mode.
## Initializes variables and prepares the first path.
func start_building_path() -> void:
	in_path_placement = true
	build_path()


## Stops path placement mode.
## Resets all path-related variables.
func stop_building_path() -> void:
	in_path_placement = false
	path_data = null
	preview.texture = null
	is_dragging_path = false
	path_preview_cells.clear()


## Instantiates a new path and configures its preview.
## Loads the path scene and configures the preview texture.
func build_path() -> void:
	path_data = load("res://scenes/buildings/Path.tscn").instantiate()
	in_path_placement = true
	preview.texture = path_data.get_preview()
	preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	effect_size = Vector2(1.0, 1.0)


## Toggles object deletion mode.
func delete_object() -> void:
	in_delete_object = !in_delete_object


## Handles drag-and-drop tracing to place multiple paths in an L-shape.
## Starts tracing on click, updates in real-time, and places all paths on release.
## [param event] The input event to process
func _handle_path_drag_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index ==SettingsValue.Pos:
		if event.pressed:
			var tile_under_mouse: Vector2i = local_to_map(to_local(get_global_mouse_position()))
			path_start_pos = tile_under_mouse
			is_dragging_path = true
			path_preview_cells.clear()
			_clear_previous_preview()
		else:
			if is_dragging_path and can_be_placed and path_preview_cells.size() > 0:
				_place_all_paths()
			is_dragging_path = false
			path_preview_cells.clear()
			_clear_previous_preview()
	
	if is_dragging_path and Input.is_mouse_button_pressed(SettingsValue.Pos):
		_update_path_l_preview()


## Updates the L-shaped path preview during tracing.
## Recalculates path cells between the start point and current mouse position.
func _update_path_l_preview() -> void:
	var tile_under_mouse: Vector2i = local_to_map(to_local(get_global_mouse_position()))
	
	path_preview_cells.clear()
	
	var cells_in_l = _get_l_shaped_path(path_start_pos, tile_under_mouse)
	path_preview_cells = cells_in_l
	
	_draw_path_preview()


## Calculates an L-shaped path between two points.
## The path consists of a horizontal or vertical segment, followed by a perpendicular segment.
## [param from] Path starting point
## [param to] Path end point
## [return] Array of cells forming the L-shaped path
func _get_l_shaped_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	
	if from == to:
		cells.append(from)
		return cells
	
	var dx = abs(to.x - from.x)
	var dy = abs(to.y - from.y)
	
	var do_horizontal_first = dx >= dy
	
	var current = from
	cells.append(current)
	
	if do_horizontal_first:
		var step_x = 1 if to.x > from.x else -1
		while current.x != to.x:
			current.x += step_x
			cells.append(Vector2i(current.x, current.y))
		
		var step_y = 1 if to.y > from.y else -1
		while current.y != to.y:
			current.y += step_y
			cells.append(Vector2i(current.x, current.y))
	else:
		var step_y = 1 if to.y > from.y else -1
		while current.y != to.y:
			current.y += step_y
			cells.append(Vector2i(current.x, current.y))
		
		var step_x = 1 if to.x > from.x else -1
		while current.x != to.x:
			current.x += step_x
			cells.append(Vector2i(current.x, current.y))
	
	return cells


## Draws the path preview on the grid.
## Checks each cell's validity and displays appropriate visual indicators.
func _draw_path_preview() -> void:
	_clear_previous_preview()
	can_be_placed = false
	
	var has_connection = false
	var all_valid = true
	
	for cell_pos in path_preview_cells:
		cell_array.append(cell_pos)
		var cell_world_pos = map_to_local(cell_pos)
		
		var is_existing_path = _cell_has_path(cell_world_pos)
		
		if is_existing_path:
			has_connection = true
			set_cell(cell_pos, 0, Vector2i(2, 0))
		else:
			var has_obstacle = _cell_collides(cell_world_pos)
			
			if has_obstacle:
				set_cell(cell_pos, 0, Vector2i(1, 0))
				all_valid = false
			else:
				if _is_adjacent_to_path(cell_world_pos):
					has_connection = true
				set_cell(cell_pos, 0, Vector2i(2, 0))
	
	can_be_placed = has_connection and all_valid
	
	if not can_be_placed:
		for cell_pos in cell_array:
			set_cell(cell_pos, 0, Vector2i(1, 0))


## Places all previewed paths in the world.
## Skips cells already occupied by paths and plays the appropriate animation.
func _place_all_paths() -> void:
	if not can_be_placed or path_preview_cells.size() == 0:
		animation.play("placementAnimationLib/invalidPlacement")
		return
	
	var placed_count = 0
	for cell_pos in path_preview_cells:
		var cell_world_pos = map_to_local(cell_pos)
		
		if _cell_has_path(cell_world_pos):
			continue
		
		var instance: Path = load("res://scenes/buildings/Path.tscn").instantiate()
		instance.position = cell_world_pos
		instance.name = "Path" + str(n_path)
		n_path += 1
		%PathRegions.add_child(instance)
		UiController.emit_validate_building_path(instance)
		placed_count += 1
	
	if placed_count > 0:
		animation.play("placementAnimationLib/goodPathPlacement")
	
	path_preview_cells.clear()
	build_path()


## Handles object deletion on click.
## Detects the clicked object and calls appropriate deletion methods.
## [param event] The input event to process
func _handle_delete_object(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.pressed and event.button_index == SettingsValue.Pos):
		return

	var mouse_pos = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state

	var query := PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_mask = 0xFFFFFFFF

	var result = space_state.intersect_point(query, 8)

	if result.size() > 0:
		var clicked = result[0].collider
		if clicked is Building:
			UiController.emit_delete_building(clicked)
		if clicked.has_method("delete"):
			clicked.delete()
