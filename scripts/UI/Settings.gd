extends Control
class_name SettingsMenu

@onready var resolution_option_button: OptionButton = $HBoxContainer/Panel/VBoxContainer/VBoxContainer/ResolutionContainer/Resolution
@onready var master_volume: HSlider = $HBoxContainer/Panel/VBoxContainer/VBoxContainer/Volume
@onready var sfx_volume: HSlider = $HBoxContainer/Panel/VBoxContainer/VBoxContainer/SFXVolume
@onready var music_volume: HSlider = $HBoxContainer/Panel/VBoxContainer/VBoxContainer/MusicVolume
@onready var fullscreen_chk = $HBoxContainer/Panel/VBoxContainer/VBoxContainer/Fullscreen

const VOLUME_MODIFIFACTOR := 50

func _ready() -> void:
	add_resolutions()
	update_button_values()
	
	if master_volume:
		master_volume.value = 50
	
	if sfx_volume:
		var sfx_bus_index = AudioServer.get_bus_index("SFX")
		if sfx_bus_index != -1:
			sfx_volume.value = 50
	
	if music_volume:
		var music_bus_index = AudioServer.get_bus_index("Music")
		if music_bus_index != -1:
			music_volume.value = 50
	
	set_process_input(true)
	
func add_resolutions():
	for r in SettingsValue.resolutions:
		resolution_option_button.add_item(r)
		
func update_button_values():
	var window_size_string = str(get_window().size.x, "x", get_window().size.y)
	var resolution_keys = SettingsValue.resolutions.keys()
	var resolution_index = resolution_keys.find(window_size_string)
	
	if resolution_index != -1:
		resolution_option_button.selected = resolution_index
	else:
		resolution_option_button.selected = 0

func _on_option_button_item_selected(index: int) -> void:
	var key = resolution_option_button.get_item_text(index)
	var new_resolution = SettingsValue.resolutions[key]
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	fullscreen_chk.button_pressed = false
	
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
		
func _on_mousse_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SettingsValue.Pos = MOUSE_BUTTON_RIGHT
		SettingsValue.Moove = MOUSE_BUTTON_LEFT
	else:
		SettingsValue.Pos = MOUSE_BUTTON_LEFT
		SettingsValue.Moove = MOUSE_BUTTON_RIGHT

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		center_window()

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value / VOLUME_MODIFIFACTOR))

func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value / VOLUME_MODIFIFACTOR))

func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value / VOLUME_MODIFIFACTOR))

func close_menu():
	hide()
	get_tree().paused = false


func _on_back_to_game_btn_pressed() -> void:
	close_menu()


func _on_quit_game_btn_pressed() -> void:
	get_tree().quit()
