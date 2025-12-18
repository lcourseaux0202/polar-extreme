extends Control


@onready var label: Label = $NinePatchRect/MarginContainer/HBoxContainer/Label
@onready var progress_bar: ProgressBar = $NinePatchRect/MarginContainer/HBoxContainer/ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiController.wellness_changed.connect(_on_wellness_changed)
	UiController.pollution_changed.connect(_on_pollution_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_wellness_changed(wellness : float) ->void :
	progress_bar.value = wellness

func _on_pollution_changed(pollution : float) ->void :
	label.text = str(round(pollution * 10.0 )/ 10.0)
