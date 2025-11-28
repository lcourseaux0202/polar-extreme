extends MarginContainer

@onready var nom: Label = $MarginContainer/Button/MarginContainer/VBoxContainer/HBoxContainer/nom
@onready var timePercentage: ProgressBar = $MarginContainer/Button/MarginContainer/VBoxContainer/ProgressBar
@onready var timer: Timer = $Timer
@onready var timeLeft: Label = $MarginContainer/Button/MarginContainer/VBoxContainer/HBoxContainer/timeLeft

var ID
var time = 30


func setName(text : String) :
	nom.text = text
	ID = int(text)

func setVisibility(vis : bool) :
	visible = vis

func _process(delta: float) -> void:
	timePercentage.value = timer.wait_time - timer.time_left
	timeLeft.text = "%d:%02d" % [floor(timer.time_left / 60), int(timer.time_left) % 60]	# pour afficher au format min:sec

func _ready() -> void:
	timer.start(time)	# temps en secondes
	timePercentage.max_value = time
