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

@onready var lbl_nb_scientist: Label = $NinePatchRect/MarginContainer/VBoxContainer/lblNbScientist

@onready var lbl_status: Label = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/lblStatus

@onready var timer: Timer = $Timer

@onready var nine_icon = $NinePatchRect/MarginContainer/VBoxContainer/nineIcon
@onready var btn_start = $NinePatchRect/MarginContainer/VBoxContainer/nineIcon/btnStart
@onready var btn_animation = $NinePatchRect/MarginContainer/VBoxContainer/nineIcon/btnStart/AnimationPlayer

@onready var lbl_time = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/lblTime

@export var icon_normal: Texture2D
@export var icon_pressed: Texture2D
@export var icon_hover: Texture2D

@onready var animation_player = $AnimationPlayer
@onready var audio = $NinePatchRect/MarginContainer/VBoxContainer/nineIcon/btnStart/AudioStart


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
	btn_start.disabled = false
	setVisibility(true)
	project = proj
	
	lbl_name.text = project.get_project_name()
	setStatus(project.get_project_state())
	lbl_nb_scientist.text = "Scientifiques nécessaires pour lancer le projet : " + str(project.requirement_scientists) 
		
	lbl_reward_nbr_sc.text = str(project.reward_science)
	if project.reward_science > 0:
		lbl_reward_nbr_sc.text = "+" + str(lbl_reward_nbr_sc.text)
		lbl_reward_nbr_sc.add_theme_color_override("font_color", Color.BLACK)
	if project.reward_science == 0:
		lbl_reward_nbr_sc.add_theme_color_override("font_color", Color.GRAY)

	lbl_reward_nbr_sc_ps.text = str(project.reward_production)
	if project.reward_production > 0:
		lbl_reward_nbr_sc_ps.text = "+" + str(project.reward_production) + " / scientifique"
		lbl_reward_nbr_sc_ps.add_theme_color_override("font_color", Color.BLACK)
	if project.reward_production == 0:
		lbl_reward_nbr_sc_ps.add_theme_color_override("font_color", Color.GRAY)

	lbl_reward_nbr_slots.text = str(project.reward_slots)
	if project.reward_slots > 0:
		lbl_reward_nbr_slots.text = "+" + str(lbl_reward_nbr_slots.text)
		lbl_reward_nbr_slots.add_theme_color_override("font_color", Color.BLACK)
	if project.reward_slots == 0:
		lbl_reward_nbr_slots.add_theme_color_override("font_color", Color.GRAY)

	lbl_reward_nbr_poll.text = str(project.reward_pollution)
	if project.reward_pollution > 0:
		lbl_reward_nbr_poll.text = "+" + str(lbl_reward_nbr_poll.text)
		lbl_reward_nbr_poll.add_theme_color_override("font_color", Color.BLACK)
	if project.reward_pollution == 0:
		lbl_reward_nbr_poll.add_theme_color_override("font_color", Color.GRAY)

	lbl_reward_nbr_poll_ps.text = str(project.reward_pollution_per_second)
	if project.reward_pollution_per_second > 0:
		lbl_reward_nbr_poll_ps.text = "+" + str(lbl_reward_nbr_poll_ps.text)
		lbl_reward_nbr_poll_ps.add_theme_color_override("font_color", Color.BLACK)
	if project.reward_pollution_per_second == 0:
		lbl_reward_nbr_poll_ps.add_theme_color_override("font_color", Color.GRAY)

	lbl_reward_nbr_wb.text = str(project.reward_wellness)
	if project.reward_wellness > 0:
		lbl_reward_nbr_wb.text = "+" + str(lbl_reward_nbr_wb.text)
		lbl_reward_nbr_wb.add_theme_color_override("font_color", Color.BLACK)
	if project.reward_wellness == 0:
		lbl_reward_nbr_wb.add_theme_color_override("font_color", Color.GRAY)

	
	lbl_time.text = str(project.project_time) + " sec."
	
	nine_icon.visible = (project.get_project_state() == 0)
	
	animation_player.play("show_g/show")


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
		lbl_status.text = "terminé"


## change the visibility of the menu
## entry : the visibility to have (bool)
func setVisibility(vis : bool) -> void:
	visible = vis


## launch the project and close the menu
func _on_btn_start_pressed() -> void:
	if project.get_project_state() == 0 and GameController.enough_scientist_for_assignement(project.requirement_scientists):
		nine_icon.texture = icon_pressed
		nine_icon.patch_margin_bottom = 10
		nine_icon.patch_margin_left = 10
		nine_icon.patch_margin_right = 10
		nine_icon.patch_margin_top = 10
		UiController.emit_start_project(project)
		btn_start.disabled = true
		nine_icon.texture = icon_normal
		audio.play()
		setVisibility(false)
	else :
		btn_animation.play("not_enough_scientist")


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
