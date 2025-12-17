extends MarginContainer

@onready var lbl_name: Label = $MarginContainer/NinePatchRect/Button/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/lblName
@onready var lbl_status: Label = $MarginContainer/NinePatchRect/Button/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/lblStatus
@onready var progress_bar: ProgressBar = $MarginContainer/NinePatchRect/Button/MarginContainer/VBoxContainer/HBoxContainer2/ProgressBar
@onready var lbl_time_left: Label = $MarginContainer/NinePatchRect/Button/MarginContainer/VBoxContainer/HBoxContainer2/lblTimeLeft
@onready var timer: Timer = $Timer


var project : Project

var project_started : bool = false


func _process(delta: float) -> void:
	if project_started == true and project.get_project_state() == 1 :
		progress_bar.value = timer.wait_time - timer.time_left
		lbl_time_left.text = "%d:%02d" % [floor(timer.time_left / 60), int(timer.time_left) % 60]	# pour afficher au format min:sec
		if timer.time_left == 0:
			project.finish()
			setStatus(project.get_project_state())


func setProject(proj : Project) -> void:
	project = proj
	instanciateProject()
	

func instanciateProject() -> void:
	lbl_name.text = project.get_project_name()
	setStatus(project.get_project_state())
	project.set_time(30)		# testttt
	progress_bar.max_value = project.get_time_total()


func setStatus(statusValue : int) -> void:
	if statusValue == 0:
		lbl_status.text = "non commencé"
	elif statusValue == 1:
		lbl_status.text = "en cours"
	elif statusValue == 2:
		lbl_status.text = "en pause"
	elif statusValue >= 3:
		lbl_status.text = "fini"


func setVisibility(vis : bool) -> void:
	visible = vis


func startProject() -> void:
	project_started = true
	project.start()
	setStatus(project.get_project_state())
	timer.start(project.get_time_total())			# temps en secondes
	print(project.get_project_state())


func _on_button_pressed() -> void:
	UiController.emit_open_project_menu(project)
