extends TileMapLayer
class_name BuildPlacement

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var preview: Sprite2D = $PreviewSprite
@onready var door: CollisionShape2D = $DoorPreview

@export var effect_size: Vector2 = Vector2(3, 3)

const IGNORED_LAYERS_FOR_BUILDING = [2]

var in_placement: bool = false
var in_path_placement : bool = false
var has_to_place_path :bool = false
var can_be_placed: bool = true
var building_data: Building
var path_data : Path
var animation_playing: bool = false  
var n_path = 0
var in_delete_object : bool = false

var placement_position: Vector2
var cell_array: Array[Vector2i] = []

var is_dragging_path: bool = false
var path_start_pos: Vector2i
var path_preview_cells: Array[Vector2i] = []

var door_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	UiController.start_building.connect(_on_building_signal)
	UiController.start_placing_path.connect(_on_path_button_pressed)
	UiController.start_delete_object.connect(delete_object)
	

func _input(event: InputEvent) -> void:
	if animation_playing:
		return
	
	_update_mouse_positions()
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if in_placement:
		_handle_rotation_input()
		_handle_placement_preview(event)
		_handle_building_click(event)
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	elif in_path_placement:
		_handle_path_drag_input(event)
		_handle_placement_preview(event)
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)
	elif in_delete_object:
		_handle_delete_object(event)
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)


func _on_building_signal(building:Building)->void:
	start_building(building)


func start_building(building: Building) -> void:
	if animation_playing:
		return
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	in_placement = true
	building_data = building

	var sprite_node: Sprite2D = building.get_node_or_null("Sprite2D")
	if sprite_node:
		preview.texture = sprite_node.texture
	
	var door_node : CollisionShape2D = building.get_node_or_null("DoorCollision")
	if door_node:
		door.shape = door_node.shape;
		door_offset = door_node.position  

		

	var building_zone: CollisionShape2D = building.get_node_or_null("BuildingZone")
	if building_zone:
		effect_size = building_zone.shape.get_rect().size / 32

func stop_building() -> void:
	in_placement = false
	in_path_placement = false
	building_data = null
	path_data = null
	preview.texture = null
	preview.rotation = 0;
	is_dragging_path = false
	path_preview_cells.clear()
	door_offset = Vector2.ZERO
	
func _update_mouse_positions() -> void:
	var mouse_pos_glob: Vector2 = get_global_mouse_position()
	var mouse_pos_grid: Vector2 = to_local(mouse_pos_glob)
	var tile_under_mouse: Vector2i = local_to_map(mouse_pos_grid)
	var world_grid_pos: Vector2 = map_to_local(tile_under_mouse)

	preview.position = world_grid_pos
	var rotated_offset = door_offset.rotated(preview.rotation)
	door.position = world_grid_pos + rotated_offset

func _handle_rotation_input() -> void:
	if Input.is_key_pressed(KEY_R):
		preview.rotate(PI / 2)
		effect_size = Vector2(effect_size.y, effect_size.x)

func _handle_placement_preview(event: InputEvent) -> void:
	if is_dragging_path:
		return
		
	_clear_previous_preview()
	can_be_placed = true

	var tile_under_mouse: Vector2i = local_to_map(to_local(get_global_mouse_position()))
	var size = effect_size.round()
	
	var start_x = -int(size.x / 2)
	var end_x =int(size.x / 2) + 1
	var start_y = -int(size.y / 2)
	var end_y = int(size.y / 2) + 1
	var is_even_x = int(size.x) % 2 == 0
	var is_even_y = int(size.y) % 2 == 0

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

		
				set_cell(cell_pos, 0, Vector2i(1, 0))

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

func _handle_building_click(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and can_be_placed:
		placement_position = preview.position
		animation_playing = true  
		animation.play("placementAnimationLib/goodPlacement")

func _clear_previous_preview() -> void:
	for cell_pos in cell_array:
		set_cell(cell_pos, 0, Vector2i(0, 0))
	cell_array.clear()

func _place_building(_anim_name: StringName) -> void:
	animation_playing = false 
	_clear_previous_preview()
	if in_placement :
		var instance: Building = building_data
		instance.rotation = preview.rotation
		instance.position = placement_position
		instance.name = instance.name + "_"+ str(building_data.get_id())
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

func get_collision_layers_mask(ignored_layers : Array):
	var collision_mask := 0xFFFFFFFF

	for layer_index in ignored_layers:
		if layer_index >= 1 and layer_index <= 32:
			collision_mask &= ~(1 << (layer_index - 1))
			
	return collision_mask
	
func _on_path_button_pressed() -> void:
	if in_path_placement:
		stop_building_path()
	else:
		start_building_path()

func start_building_path() -> void:
	in_path_placement = true
	has_to_place_path = false
	build_path()

func stop_building_path() -> void:
	in_path_placement = false
	path_data = null
	preview.texture = null
	has_to_place_path = false
	is_dragging_path = false
	path_preview_cells.clear()
	return

func build_path():
	path_data = load("res://scenes/buildings/Path.tscn").instantiate()
	in_path_placement = true
	preview.texture = path_data.get_preview()
	preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	effect_size = Vector2(1.0, 1.0)


func delete_object():
	in_delete_object = !in_delete_object

func _handle_path_drag_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
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
	
	elif is_dragging_path:
		_update_path_preview()

func _update_path_preview() -> void:
	_clear_previous_preview()
	path_preview_cells.clear()
	can_be_placed = true
	
	var tile_under_mouse: Vector2i = local_to_map(to_local(get_global_mouse_position()))
	
	var cells_in_line = _get_line_cells(path_start_pos, tile_under_mouse)
	
	var at_least_one_connected = false
	
	for cell_pos in cells_in_line:
		path_preview_cells.append(cell_pos)
		cell_array.append(cell_pos)
		var cell_world_pos: Vector2 = map_to_local(cell_pos)
		
		var has_collision = _cell_collides(cell_world_pos)
		var is_adjacent_to_path = _is_adjacent_to_path(cell_world_pos)
		
		if is_adjacent_to_path:
			at_least_one_connected = true
		
		if has_collision:
			set_cell(cell_pos, 0, Vector2i(1, 0))
			can_be_placed = false
		elif not at_least_one_connected and cell_pos != cells_in_line[cells_in_line.size() - 1]:
			set_cell(cell_pos, 0, Vector2i(2, 0))
		else:
			set_cell(cell_pos, 0, Vector2i(2, 0))
	
	if not at_least_one_connected:
		can_be_placed = false
		for cell_pos in cell_array:
			set_cell(cell_pos, 0, Vector2i(1, 0))

func _get_line_cells(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var current = from
	
	while current.x != to.x:
		cells.append(current)
		if current.x < to.x:
			current.x += 1
		else:
			current.x -= 1
	
	while current.y != to.y:
		cells.append(current)
		if current.y < to.y:
			current.y += 1
		else:
			current.y -= 1
	
	cells.append(to)
	
	return cells

func _place_all_paths() -> void:
	for cell_pos in path_preview_cells:
		var cell_world_pos = map_to_local(cell_pos)
		var instance: Path = load("res://scenes/buildings/Path.tscn").instantiate()
		instance.position = cell_world_pos
		instance.name = "Path" + str(n_path)
		n_path += 1
		%PathRegions.add_child(instance)
		UiController.emit_validate_building_path(instance)
	
	build_path()
	
	
	
func _handle_delete_object(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
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
