extends TileMapLayer

var effect_size : int = 9
var celle_array : Array[Vector2i] = []
var previous_mouse_pos : Vector2i = Vector2i(-100, -100) 

var building_scene = preload("res://scenes/buildings/default_building.tscn")
var can_be_placed : bool = true
var preview : Sprite2D
var test : BaseBuilding

func _ready() -> void:
	preview = $preview
	test = building_scene.instantiate()
	preview.texture = test.michelle


func _input(_event: InputEvent) -> void:
	
	
	var mouse_pos_glob: Vector2 = get_global_mouse_position()
	var mouse_pos_grid: Vector2 = to_local(mouse_pos_glob)
	var tile_under_mouse_pos: Vector2i = local_to_map(mouse_pos_grid)
	var world_grid_pos = map_to_local(tile_under_mouse_pos)
	preview.position = map_to_local(tile_under_mouse_pos) 

	can_be_placed = true

	for cell_pos in celle_array:
		set_cell(cell_pos, 0, Vector2i(0, 0))
	celle_array.clear()

	# Vérification pour la grille
	for i in range(int(-effect_size / 2), int(effect_size / 2) + 1):
		for j in range(int(-effect_size / 2), int(effect_size / 2) + 1):
			var pos: Vector2i = tile_under_mouse_pos + Vector2i(i, j)
			if not celle_array.has(pos):
				celle_array.append(pos)
				var cell_world_pos: Vector2 = map_to_local(pos)
				if _cell_collides(cell_world_pos):
					set_cell(pos, 0, Vector2i(1, 0))
					can_be_placed = false
				else:
					set_cell(pos, 0, Vector2i(2, 0))

	if _event is InputEventMouseButton:
		if _event.button_index == MOUSE_BUTTON_LEFT and _event.pressed:
			_place_building(world_grid_pos)

func _place_building(world_grid_pos: Vector2) -> void:
	if can_be_placed:
		test.position = world_grid_pos  
		get_parent().add_child(test) 
		test = building_scene.instantiate() 
	else:
		print("nop")
		
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

	var result = space_state.intersect_shape(query, 1)
	return result.size() > 0
