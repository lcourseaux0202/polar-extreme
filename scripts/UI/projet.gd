extends MarginContainer

@onready var nom: Label = $MarginContainer/NinePatchRect/Button/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/nom
@onready var status: Label = $MarginContainer/NinePatchRect/Button/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/timeLeft
@onready var timePercentage: ProgressBar = $MarginContainer/NinePatchRect/Button/MarginContainer/VBoxContainer/ProgressBar

var timeTotal : int
var timeLeft : int


func setName(text : String) :
	nom.text = text
	
func setStatus(statusValue : int) :
	if statusValue == 0:
		status.text = "non commencé"
	elif statusValue == 1:
		status.text = "en cours"
	elif statusValue == 2:
		status.text = "en pause"
	elif statusValue >= 3:
		status.text = "fini"
	
func setTime(time : int) :
	timeTotal = time
	timePercentage.max_value = timeTotal
	
func setTimeLeft(time : int) :
	timeLeft = time

func setVisibility(vis : bool) :
	visible = vis

func _process(delta: float) -> void:
	pass
	#timeLeft.text = "%d:%02d" % [floor(timer.time_left / 60), int(timer.time_left) % 60]	# pour afficher au format min:sec

func _ready() -> void:
	pass
	#timer.start(time)	# temps en secondes
	#timePercentage.max_value = time


func _on_mouse_entered() -> void:
	UiController.emit_lock_scroll_cam(true)
	UiController.emit_lock_scroll_cam(true)
	UiController.emit_lock_scroll_cam(true)
	UiController.emit_lock_scroll_cam(true)


func _on_mouse_exited() -> void:
	UiController.emit_lock_scroll_cam(false)
	UiController.emit_lock_scroll_cam(false)
	UiController.emit_lock_scroll_cam(false)
	UiController.emit_lock_scroll_cam(false)
	


func _on_button_pressed() -> void:
	pass # Replace with function body.
