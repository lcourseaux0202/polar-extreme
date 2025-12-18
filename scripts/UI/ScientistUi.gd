extends MarginContainer
class_name ScientistMenu
## displays the numbers of scientists
## allows to recruit scientists and can oper another menu to add them to the buildings

@onready var menu_add_scientist_to_building: MarginContainer = $HBoxContainer/MenuAddScientistToBuilding

@onready var lbl_nbr_spaces: Label = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer3/lblNbrSpaces
@onready var lbl_nbr_unassigned: Label = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer4/lblNbrUnassigned
@onready var lbl_nbr_assigned: Label = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/lblNbrAssigned

@onready var btn_recruit: Button = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/nineIcon/btnRecruit
@onready var audio_recruit: AudioStreamPlayer2D = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/nineIcon/btnRecruit/AudioRecruit

@onready var animation: AnimationPlayer = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/nineIcon/btnRecruit/AnimationPlayer
@onready var nine_icon: NinePatchRect = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/nineIcon

@export var icon_normal: Texture2D
@export var icon_pressed: Texture2D
@export var icon_hover: Texture2D

signal not_enough_science()


## connects the signals and update the price of the scientists
func _ready() -> void:
	UiController.update_assign_scientist.connect(_on_update_assign_scientist)
	UiController.update_deassign_scientist.connect(_on_update_deassign_scientist)
	_update_recruit_price()


## shows the menu MenuAddScientistToBuilding or hides it
func _on_button_pressed() -> void:
	if (!menu_add_scientist_to_building.visible):
		menu_add_scientist_to_building.visible = true
		_update_recruit_price()
	else:
		menu_add_scientist_to_building.visible = false


## hides the menu MenuAddScientistToBuilding and update the prices and texts
func _on_visibility_changed() -> void:
	if visible:
		menu_add_scientist_to_building.visible = false
		_update_assign_text()
		_update_recruit_price()
		_update_free_spaces()
		


## recruits a scientist
func _on_btn_recruit_pressed() -> void:
	nine_icon.texture = icon_pressed
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10
	var status : int = GameController.pay_scientist()
	if status == 0:
		UiController.emit_enroll_scientist()
		audio_recruit.play()
		_update_assign_text()
		_update_recruit_price()
		_update_free_spaces()
	else:
		if not animation.is_playing():
			if status == 1:
				animation.play("not_enough_credit")
				btn_recruit.text = "Science insuffisante ! "
			else:
				animation.play("not_enough_credit")
				btn_recruit.text = "Pas assez de place !\n Construisez des chambres..."
	nine_icon.texture = icon_normal


## update the number of scientist displayed
func _on_update_assign_scientist():
	_update_assign_text()
	_update_free_spaces()


## update the number of scientist displayed
func _on_update_deassign_scientist():
	_update_assign_text()
	_update_free_spaces()

## update the price displayed
func _update_recruit_price():
	btn_recruit.text = "Recruter (Coût : " + str(int(GameController.scientist_manager.get_scientist_price())) + ")"


## update the number of scientist displayed
func _update_assign_text():
	lbl_nbr_assigned.text = str(GameController.scientist_manager.get_scientist_occupied())
	lbl_nbr_unassigned.text = str(GameController.scientist_manager.get_scientist_non_occupied())

func _update_free_spaces():
	lbl_nbr_spaces.text = str(GameController.building_manager.get_free_spaces() - GameController.scientist_manager.get_scientist_total())

## change the icon of the button
func _on_btn_recruit_mouse_entered() -> void:
	nine_icon.texture = icon_hover
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10


## change the icon of the button
func _on_btn_recruit_mouse_exited() -> void:
	nine_icon.texture = icon_normal
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10
