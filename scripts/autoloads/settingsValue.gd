extends CanvasLayer

var gui_components = [
	"res://scenes/UI/MenuSettings.tscn"
]

var Moove: MouseButton = MOUSE_BUTTON_RIGHT
var Pos: MouseButton = MOUSE_BUTTON_LEFT

var main_menu = preload("res://scenes/UI/MainMenu.tscn")

var resolutions = {
	"1920x1080": Vector2i(1920, 1080),
	"1600x900": Vector2i(1600, 900),
	"1440x900": Vector2i(1440, 900),
	"1366x768": Vector2i(1366, 768),
}

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100 
	for i in gui_components:
		var new_scene = load(i).instantiate()
		new_scene.process_mode = Node.PROCESS_MODE_ALWAYS
		add_child(new_scene)
		new_scene.hide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		open()

func open() -> void:
	var settings_menu = get_node("SettingsMenu")
	settings_menu.visible = !settings_menu.visible
	get_tree().paused = settings_menu.visible
	
	if settings_menu.visible:
		settings_menu.update_button_values()
