extends Camera2D

@export var min_zoom: float = 1.0
@export var max_zoom: float = 4.0
@export var zoom_speed: float = 0.01
@export var drag_button: MouseButton = MOUSE_BUTTON_LEFT

@export var world_min: Vector2 = Vector2(-100, -100)
@export var world_max: Vector2 = Vector2(3750, 2500)

var dragging := false
var locked := false


func _unhandled_input(event: InputEvent) -> void:
	if locked:
		return

	if event is InputEventMouseButton:
		if event.button_index == drag_button:
			dragging = event.pressed

		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_towards_mouse(1.0 + zoom_speed)

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_towards_mouse(1.0 - zoom_speed)

	if event is InputEventMouseMotion and dragging:
		global_position -= event.relative / zoom
		clamp_camera_to_world()

func _zoom_towards_mouse(factor: float) -> void:
	var mouse_screen := get_viewport().get_mouse_position()
	var world_before := screen_to_world(mouse_screen)
	var new_zoom := zoom * factor
	new_zoom = new_zoom.clamp(
		Vector2(min_zoom, min_zoom),
		Vector2(max_zoom, max_zoom)
	)

	zoom = new_zoom
	var world_after := screen_to_world(mouse_screen)
	global_position += world_before - world_after

	clamp_camera_to_world()


func screen_to_world(screen_pos: Vector2) -> Vector2:
	var viewport_center := get_viewport_rect().size * 0.5
	return global_position + (screen_pos - viewport_center) / zoom


func clamp_camera_to_world() -> void:
	var half_view := (get_viewport_rect().size * 0.5) / zoom

	global_position.x = clamp(
		global_position.x,
		world_min.x + half_view.x,
		world_max.x - half_view.x
	)

	global_position.y = clamp(
		global_position.y,
		world_min.y + half_view.y,
		world_max.y - half_view.y
	)
