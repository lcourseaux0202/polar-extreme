extends Control
## displays the gauges of wellness and pollution

@onready var wellness_bar: ProgressBar = $WellnessBar/MarginContainer/ProgressBar
@onready var pollution_bar: ProgressBar = $PollutionBar/MarginContainer/ProgressBar


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
	wellness_bar.value = 200 - wellness


## updates the pollution
## entry : the pollution (float)
func _on_pollution_changed(pollution : float) ->void :
	pollution_bar.value = round(pollution * 10.0 )/ 10.0

func _on_progress_bar_mouse_entered() -> void:
	wellness_bar.show_percentage = true


func _on_progress_bar_mouse_exited() -> void:
	wellness_bar.show_percentage = false
