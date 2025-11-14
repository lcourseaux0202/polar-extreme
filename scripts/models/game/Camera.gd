extends Camera2D

var min_zoom: float = 0.5
var max_zoom: float = 3.0
var zoom_speed: float = 0.1
var drag_button: MouseButton = MOUSE_BUTTON_LEFT
var smooth_zoom: bool = true

var dragging := false
var velocity := Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == drag_button:
			dragging = event.pressed
	
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_towards_mouse(1 - zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_towards_mouse(1 + zoom_speed)

	if event is InputEventMouseMotion and dragging:
		position -= event.relative / zoom.x   
		
		
func _zoom_towards_mouse(factor: float) -> void:
	var new_zoom = zoom * factor
	new_zoom = new_zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

	if smooth_zoom:
		zoom = zoom.lerp(new_zoom, 0.25)
	else:
		zoom = new_zoom

	var mouse_pos = get_viewport().get_mouse_position()
	var world_before = to_global(mouse_pos)
	var world_after = to_global(mouse_pos)
	position += world_before - world_after
