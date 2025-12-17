extends MarginContainer
class_name ScientistMenu

@onready var menu_assignation_scientifiques: MarginContainer = $HBoxContainer/MenuAssignationScientifiques
@onready var nbr_assigned: Label = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/nbrAssigned
@onready var nbr_unassigned: Label = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer3/nbrUnassigned
@onready var btn_recruit: Button = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/NinePatchRect/btnRecruit
@onready var animation: AnimationPlayer = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/NinePatchRect/btnRecruit/AnimationPlayer

signal not_enough_science()

func _ready() -> void:
	UiController.update_assign_scientist.connect(_on_update_assign_scientist)
	UiController.update_deassign_scientist.connect(_on_update_deassign_scientist)
	_update_recruit_price()


func _on_button_pressed() -> void:
	if (!menu_assignation_scientifiques.visible):
		menu_assignation_scientifiques.visible = true
		_update_recruit_price()
	else:
		menu_assignation_scientifiques.visible = false


func _on_visibility_changed() -> void:
	if visible:
		menu_assignation_scientifiques.visible = false
		_update_assign_text()
		_update_recruit_price()

	
func _on_btn_recruit_pressed() -> void:
	if GameController.pay_scientist():
		UiController.emit_enroll_scientist()
		_update_assign_text()
		_update_recruit_price()
	else:
		if not animation.is_playing():
			animation.play("not_enough_credit")
			not_enough_science.emit()

func _on_update_assign_scientist():
	_update_assign_text()

func _on_update_deassign_scientist():
	_update_assign_text()

func _update_recruit_price():
	btn_recruit.text = "Recruter (" + str(int(GameController.scientist_manager.get_scientist_price())) + ")"

func _update_assign_text():
	nbr_assigned.text = str(GameController.scientist_manager.get_scientist_occupied())
	nbr_unassigned.text = str(GameController.scientist_manager.get_scientist_non_occupied())
