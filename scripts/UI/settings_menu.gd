extends Control
class_name SettingsMenu

@onready var resolution_option_button: OptionButton = $Panel/HBoxContainer/VBoxContainer/ResolutionContainer/Resolution

func _ready() -> void:
	add_resolutions()
	update_button_values()
	$Panel/HBoxContainer/VBoxContainer/Volume.value = db_to_linear(AudioServer.get_bus_volume_db(0))

func add_resolutions():
	for r in GuiAutoload.resolutions:
		resolution_option_button.add_item(r)
		
func update_button_values():
	var window_size_string = str(get_window().size.x, "x", get_window().size.y)
	var resolution_index = GuiAutoload.gui_components.find(window_size_string)
	resolution_option_button.selected = resolution_index

func _on_option_button_item_selected(index: int) -> void:
	var key = resolution_option_button.get_item_text(index)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	get_window().set_size(GuiAutoload.resolutions[key])
	center_window()

func center_window():
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen_center - window_size / 2)


func _on_v_sync_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$Panel/HBoxContainer/VBoxContainer/ResolutionContainer/Resolution.disabled = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		center_window()
		$Panel/HBoxContainer/VBoxContainer/ResolutionContainer/Resolution.disabled = false


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
