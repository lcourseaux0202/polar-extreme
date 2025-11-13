extends TileMapLayer
class_name BuildPlacement

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var preview: Sprite2D = $PreviewSprite

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

var placement_position: Vector2
var cell_array: Array[Vector2i] = []


func _ready() -> void:
	UIController.start_building.connect(_on_building_signal)
	UIController.start_placing_path.connect(_on_path_button_pressed)
	

func _input(event: InputEvent) -> void:
	if animation_playing:
		return
	
	_update_mouse_positions()
	if in_placement:
		_handle_rotation_input()
		_handle_placement_preview(event)
		_handle_building_click(event)
	elif in_path_placement:
		_handle_placement_preview(event)
		_handle_building_click(event)


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

	var building_zone: CollisionShape2D = building.get_node_or_null("BuildingZone")
	if building_zone:
		effect_size = building_zone.shape.get_rect().size / 32

func stop_building() -> void:
	in_placement = false
	in_path_placement = false
	building_data = null
	path_data = null
	preview.texture = null
	
func _update_mouse_positions() -> void:
	var mouse_pos_glob: Vector2 = get_global_mouse_position()
	var mouse_pos_grid: Vector2 = to_local(mouse_pos_glob)
	var tile_under_mouse: Vector2i = local_to_map(mouse_pos_grid)
	var world_grid_pos: Vector2 = map_to_local(tile_under_mouse)

	preview.position = world_grid_pos

func _handle_rotation_input() -> void:
	if Input.is_key_pressed(KEY_R):
		preview.rotate(PI / 2)

func _handle_placement_preview(event: InputEvent) -> void:
	_clear_previous_preview()
	can_be_placed = true

	var tile_under_mouse: Vector2i = local_to_map(to_local(get_global_mouse_position()))
	var size = effect_size.round()

	for i in range(-size.x / 2, size.x / 2 + 1):
		for j in range(-size.y / 2, size.y / 2 + 1):
			var pos: Vector2i = tile_under_mouse + Vector2i(i, j)
			cell_array.append(pos)
			var cell_world_pos: Vector2 = map_to_local(pos)
			if _cell_collides(cell_world_pos):
				set_cell(pos, 0, Vector2i(1, 0))
				can_be_placed = false
			else:
				set_cell(pos, 0, Vector2i(2, 0))

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
		instance.name = instance.name + "_" ;
		#+ str(building_data.get_id())
		%WorldGrid.add_child(instance)
		#GameController.add_building(instance)
		UIController.emit_validate_building_placement(instance)
		stop_building()
	elif in_path_placement:
		var instance: Path = path_data
		instance.position = placement_position
		instance.name = "Path" + str(n_path)
		n_path += 1
		%PathRegions.add_child(instance)
		UIController.emit_validate_building_path(instance)
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
	return

func build_path():
	path_data = load("res://v2/scenes/buildings/Path.tscn").instantiate()
	in_path_placement = true
	preview.texture = path_data.get_preview()
	preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	effect_size = Vector2(1.0, 1.0)
