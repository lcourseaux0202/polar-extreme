extends MarginContainer
## displays the project running (name, status, time left)

@onready var lbl_name: Label = $MarginContainer/ninIcon/btnOpenInfos/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/lblName
@onready var lbl_status: Label = $MarginContainer/ninIcon/btnOpenInfos/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/lblStatus
@onready var progress_bar: ProgressBar = $MarginContainer/ninIcon/btnOpenInfos/MarginContainer/VBoxContainer/HBoxContainer2/ProgressBar
@onready var lbl_time_left: Label = $MarginContainer/ninIcon/btnOpenInfos/MarginContainer/VBoxContainer/HBoxContainer2/lblTimeLeft
@onready var container_timer = $MarginContainer/ninIcon/btnOpenInfos/MarginContainer/VBoxContainer/HBoxContainer2

@onready var timer: Timer = $Timer
@onready var nine_icon: NinePatchRect = $MarginContainer/ninIcon


@export var icon_normal: Texture2D
@export var icon_pressed: Texture2D
@export var icon_hover: Texture2D


var project : Project

var project_started : bool = false


## if the project is started, updates and displays the time left
func _process(_delta: float) -> void:
	if project_started == true and project.get_project_state() == 1 :
		progress_bar.value = timer.wait_time - timer.time_left
		lbl_time_left.text = "%d:%02d" % [floor(timer.time_left / 60), int(timer.time_left) % 60]	# pour afficher au format min:sec
		if timer.time_left == 0:
			project.finish()
			setStatus(project.get_project_state())


## sets a project to the menu
## entry : the project (Project)
func setProject(proj : Project) -> void:
	project = proj
	instanciateProject()


## returns the project
## return : the project (Project)
func getProject() -> Project:
	return project
	

## fills the informations
func instanciateProject() -> void:
	lbl_name.text = project.get_project_name()
	setStatus(project.get_project_state())
	project.set_time(30)		# testttt
	progress_bar.max_value = project.get_time_total()


## show the status of the project
## entry : the status of the project (int)
func setStatus(statusValue : int) -> void:
	if statusValue == 0:
		lbl_status.text = "non commencé"
	elif statusValue == 1:
		lbl_status.text = "en cours"
	elif statusValue == 2:
		lbl_status.text = "en pause"
	elif statusValue >= 3:
		lbl_status.text = "fini"


## change the visibility of the menu
## entry : the visibility to have (bool), if timer is displayed (bool)
func setVisibility(vis : bool, timer_displayed : bool) -> void:
	visible = vis
	container_timer.visible = timer_displayed


## start the project
func startProject() -> void:
	project_started = true
	project.start()
	setStatus(project.get_project_state())
	timer.start(project.get_time_total())			# temps en secondes
	print(project.get_project_state())


## change the icon of the button and open the SubMenuShowProjectInfos
func _on_button_pressed() -> void:
	nine_icon.texture = icon_pressed
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10
	UiController.emit_open_project_menu(project)
	nine_icon.texture = icon_normal


## change the icon of the button
func _on_button_mouse_entered() -> void:
	nine_icon.texture = icon_hover
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10


## change the icon of the button
func _on_button_mouse_exited() -> void:
	nine_icon.texture = icon_normal
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10
