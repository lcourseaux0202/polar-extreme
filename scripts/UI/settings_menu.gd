extends Control
class_name SettingsMenu

@onready var resolution_option_button: OptionButton = $Panel/HBoxContainer/VBoxContainer/ResolutionContainer/Resolution
@onready var master_volume: HSlider = $Panel/HBoxContainer/VBoxContainer/Volume
@onready var sfx_volume: HSlider = $Panel/HBoxContainer/VBoxContainer/SFXVolume
@onready var music_volume: HSlider = $Panel/HBoxContainer/VBoxContainer/MusicVolume

func _ready() -> void:
	add_resolutions()
	update_button_values()
	
	# Debug - afficher les noms des bus
	print("Nombre de bus: ", AudioServer.bus_count)
	for i in AudioServer.bus_count:
		print("Bus ", i, ": ", AudioServer.get_bus_name(i))
	
	# Initialize volume sliders with current bus volumes
	if master_volume:
		master_volume.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	
	if sfx_volume:
		var sfx_bus_index = AudioServer.get_bus_index("SFX")
		print("Index du bus SFX: ", sfx_bus_index)
		if sfx_bus_index != -1:
			sfx_volume.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index))
	
	if music_volume:
		var music_bus_index = AudioServer.get_bus_index("Music")
		print("Index du bus Music: ", music_bus_index)
		if music_bus_index != -1:
			music_volume.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))
	
	set_process_input(true)
func add_resolutions():
	for r in settingsValue.resolutions:
		resolution_option_button.add_item(r)
		
func update_button_values():
	var window_size_string = str(get_window().size.x, "x", get_window().size.y)
	var resolution_keys = settingsValue.resolutions.keys()
	var resolution_index = resolution_keys.find(window_size_string)
	
	if resolution_index != -1:
		resolution_option_button.selected = resolution_index
	else:
		resolution_option_button.selected = 0

func _on_option_button_item_selected(index: int) -> void:
	var key = resolution_option_button.get_item_text(index)
	var new_resolution = settingsValue.resolutions[key]
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	get_window().content_scale_size = new_resolution
	
	get_window().size = new_resolution
	
	center_window()

func center_window():
	var window = get_window()
	if window.mode == Window.MODE_WINDOWED:
		if not Engine.is_editor_hint():
			var screen_center = DisplayServer.screen_get_position(0) + DisplayServer.screen_get_size(0) / 2
			var window_size = window.get_size_with_decorations()
			window.position = screen_center - window_size / 2

func _on_v_sync_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		center_window()

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func close_menu():
	hide()
	get_tree().paused = false
