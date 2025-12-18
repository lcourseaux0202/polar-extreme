extends Control
class_name MainMenu

@onready var quit_game_btn: Button = $VBoxContainer/QuitGameBtn
@onready var start_game_btn: Button = $VBoxContainer/StartGameBtn
@onready var tutorial = preload("res://scenes/UI/Tutorial.tscn")

var hover_scale := Vector2(1.02,1.02)

func _ready() -> void:
	start_game_btn.mouse_entered.connect(_start_button_enter)
	start_game_btn.mouse_exited.connect(_start_button_exit)
	start_game_btn.pressed.connect(_start_game)
	quit_game_btn.mouse_entered.connect(_quit_button_enter)
	quit_game_btn.mouse_exited.connect(_quit_button_exit)
	quit_game_btn.pressed.connect(_quit_game)
	call_deferred("init_pivot")
	
func init_pivot():
	start_game_btn.pivot_offset = size / 2.0
	quit_game_btn.pivot_offset = size / 2.0

func _start_button_enter():
	create_tween().tween_property(start_game_btn, "scale", hover_scale, 0.1).set_trans(Tween.TRANS_SINE)
	
func _start_button_exit():
	create_tween().tween_property(start_game_btn, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)

func _quit_button_enter():
	create_tween().tween_property(quit_game_btn, "scale", hover_scale, 0.1).set_trans(Tween.TRANS_SINE)
	
func _quit_button_exit():
	create_tween().tween_property(quit_game_btn, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)

func _start_game():
	get_tree().change_scene_to_packed(tutorial)

func _quit_game():
	get_tree().quit()
