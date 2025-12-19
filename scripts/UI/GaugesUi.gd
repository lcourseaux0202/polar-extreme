extends Control
## displays the gauges of wellness and pollution

@onready var wellness_bar: ProgressBar = $WellnessBar/MarginContainer/ProgressBar
@onready var pollution_bar: ProgressBar = $PollutionBar/MarginContainer/ProgressBar
@onready var label: Label = $WellnessBar/MarginContainer/ProgressBar/Label


# Called when the node enters the scene tree for the first time.
## connect the signals
func _ready() -> void:
	UiController.wellness_changed.connect(_on_wellness_changed)
	UiController.pollution_changed.connect(_on_pollution_changed)
	wellness_bar.min_value = GameController.gauges.wellness_min
	wellness_bar.max_value = GameController.gauges.wellness_max

## updates the wellness
## entry : the wellness (float)
func _on_wellness_changed(wellness : float) ->void :
	# wellness_bar.value = GameController.gauges.wellness_max - wellness - GameController.gauges.wellness_min
	wellness_bar.value = wellness
	print("wellness changed :" + str(wellness))


## updates the pollution
## entry : the pollution (float)
func _on_pollution_changed(pollution : float) ->void :
	pollution_bar.value = int(pollution)

func _on_progress_bar_mouse_entered() -> void:
	#wellness_bar.show_percentage = true
	label.text = str(int(wellness_bar.value))
	
func _on_progress_bar_mouse_exited() -> void:
	#wellness_bar.show_percentage = false
	label.text = ""


func _on_pollution_bar_mouse_entered():
	pollution_bar.show_percentage = true

func _on_pollution_bar_mouse_exited():
	pollution_bar.show_percentage = false
