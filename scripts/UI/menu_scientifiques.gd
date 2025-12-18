extends MarginContainer
class_name ScientistMenu

@onready var menu_add_scientist_to_building: MarginContainer = $HBoxContainer/MenuAddScientistToBuilding

@onready var lbl_nbr_unassigned: Label = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer3/lblNbrUnassigned

@onready var lbl_nbr_assigned: Label = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/lblNbrAssigned

@onready var btn_recruit: Button = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/nineIcon/btnRecruit

@onready var animation: AnimationPlayer = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/nineIcon/btnRecruit/AnimationPlayer
@onready var nine_icon: NinePatchRect = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/nineIcon

@export var icon_normal: Texture2D
@export var icon_pressed: Texture2D
@export var icon_hover: Texture2D

signal not_enough_science()


func _ready() -> void:
	UiController.update_assign_scientist.connect(_on_update_assign_scientist)
	UiController.update_deassign_scientist.connect(_on_update_deassign_scientist)
	_update_recruit_price()


func _on_button_pressed() -> void:
	if (!menu_add_scientist_to_building.visible):
		menu_add_scientist_to_building.visible = true
		_update_recruit_price()
	else:
		menu_add_scientist_to_building.visible = false


func _on_visibility_changed() -> void:
	if visible:
		menu_add_scientist_to_building.visible = false
		_update_assign_text()
		_update_recruit_price()

	
func _on_btn_recruit_pressed() -> void:
	nine_icon.texture = icon_pressed
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10
	if GameController.pay_scientist():
		UiController.emit_enroll_scientist()
		_update_assign_text()
		_update_recruit_price()
	else:
		if not animation.is_playing():
			animation.play("not_enough_credit")
			not_enough_science.emit()
	nine_icon.texture = icon_normal

func _on_update_assign_scientist():
	_update_assign_text()

func _on_update_deassign_scientist():
	_update_assign_text()

func _update_recruit_price():
	btn_recruit.text = "Recruter (Coût : " + str(int(GameController.scientist_manager.get_scientist_price())) + ")"

func _update_assign_text():
	lbl_nbr_assigned.text = str(GameController.scientist_manager.get_scientist_occupied())
	lbl_nbr_unassigned.text = str(GameController.scientist_manager.get_scientist_non_occupied())


func _on_btn_recruit_mouse_entered() -> void:
	nine_icon.texture = icon_hover
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10


func _on_btn_recruit_mouse_exited() -> void:
	nine_icon.texture = icon_normal
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10
