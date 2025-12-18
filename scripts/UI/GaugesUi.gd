extends Control
## displays the gauges of wellness and pollution

@onready var label: Label = $NinePatchRect/MarginContainer/HBoxContainer/Label
@onready var progress_bar: ProgressBar = $NinePatchRect/MarginContainer/HBoxContainer/NinePatchRect/MarginContainer/ProgressBar


# Called when the node enters the scene tree for the first time.
## connect the signals
func _ready() -> void:
	UiController.wellness_changed.connect(_on_wellness_changed)
	UiController.pollution_changed.connect(_on_pollution_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## updates the wellness
## entry : the wellness (float)
func _on_wellness_changed(wellness : float) ->void :
	progress_bar.value = wellness


## updates the pollution
## entry : the pollution (float)
func _on_pollution_changed(pollution : float) ->void :
	label.text = str(round(pollution * 10.0 )/ 10.0)


func _on_nine_patch_rect_mouse_entered() -> void:
	progress_bar.show_percentage = true

func _on_nine_patch_rect_mouse_exited() -> void:
	progress_bar.show_percentage = false
