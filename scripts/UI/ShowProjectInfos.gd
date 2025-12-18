extends MarginContainer
## opens a menu containing the informations of the project clicked
## shows the name, the gains, the description, the status and the time of the project
## the player can launch the project if it hasn't been done already

@onready var lbl_name: Label = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer3/lblName

@onready var lbl_reward_nbr_sc: Label = $NinePatchRect/MarginContainer/VBoxContainer/VBoxContainer/GridContainer/HBoxContainer/lblRewardNbrSc
@onready var lbl_reward_nbr_sc_ps: Label = $NinePatchRect/MarginContainer/VBoxContainer/VBoxContainer/GridContainer/HBoxContainer2/lblRewardNbrScPS
@onready var lbl_reward_nbr_slots: Label = $NinePatchRect/MarginContainer/VBoxContainer/VBoxContainer/GridContainer/HBoxContainer3/lblRewardNbrSlots
@onready var lbl_reward_nbr_poll: Label = $NinePatchRect/MarginContainer/VBoxContainer/VBoxContainer/GridContainer/HBoxContainer4/lblRewardNbrPoll
@onready var lbl_reward_nbr_poll_ps: Label = $NinePatchRect/MarginContainer/VBoxContainer/VBoxContainer/GridContainer/HBoxContainer5/lblRewardNbrPollPS
@onready var lbl_reward_nbr_wb: Label = $NinePatchRect/MarginContainer/VBoxContainer/VBoxContainer/GridContainer/HBoxContainer6/lblRewardNbrWB

@onready var lbl_desc: Label = $NinePatchRect/MarginContainer/VBoxContainer/lblDesc

@onready var lbl_status: Label = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/lblStatus

@onready var progress_bar: ProgressBar = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/ProgressBar
@onready var lbl_time_left: Label = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/lblTimeLeft
@onready var timer: Timer = $Timer

@onready var nine_icon: NinePatchRect = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/nineIcon
@onready var btn_start: Button = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/nineIcon/btnStart

@export var icon_normal: Texture2D
@export var icon_pressed: Texture2D
@export var icon_hover: Texture2D


var project : Project

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	UiController.open_project_menu.connect(_on_open_project_menu) ## connect the signal to the function


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
## opens the menu and fills the informations
## entry : the project (Project)
func _on_open_project_menu(proj : Project) -> void:
	setVisibility(true)
	project = proj
	
	lbl_name.text = project.get_project_name()
	setStatus(project.get_project_state())
	lbl_desc.text = project.get_description()
	
	lbl_reward_nbr_sc.text = str(project.reward_science)
	lbl_reward_nbr_sc_ps.text = str(project.reward_production)
	lbl_reward_nbr_slots.text = str(project.reward_slots)
	lbl_reward_nbr_poll.text = str(project.reward_pollution)
	lbl_reward_nbr_poll_ps.text = str(project.reward_pollution_per_second)
	lbl_reward_nbr_wb.text = str(project.reward_wellness)
	
	#lbl_time_left.text = str(project.get_time_total())
	
	if project.get_project_state() != 0 :
		btn_start.disabled = true


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
## entry : the visibility to have (bool)
func setVisibility(vis : bool) -> void:
	visible = vis


## launch the project and close the menu
func _on_btn_start_pressed() -> void:
	if (project.get_project_state() == 0):
		nine_icon.texture = icon_pressed
		nine_icon.patch_margin_bottom = 10
		nine_icon.patch_margin_left = 10
		nine_icon.patch_margin_right = 10
		nine_icon.patch_margin_top = 10
		UiController.emit_start_project(project)
		btn_start.disabled = true
		nine_icon.texture = icon_normal
		setVisibility(false)


## close the menu
func _on_btn_quit_pressed() -> void:
	setVisibility(false)


## change the icon of the button
func _on_btn_start_mouse_entered() -> void:
	if project.get_project_state() == 0 :
		nine_icon.texture = icon_hover
		nine_icon.patch_margin_bottom = 10
		nine_icon.patch_margin_left = 10
		nine_icon.patch_margin_right = 10
		nine_icon.patch_margin_top = 10


## change the icon of the button
func _on_btn_start_mouse_exited() -> void:
	nine_icon.texture = icon_normal
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10
