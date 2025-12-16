extends MarginContainer
class_name ScientistMenu

@onready var menu_assignation_scientifiques: MarginContainer = $HBoxContainer/MenuAssignationScientifiques
@onready var nbr_assigned: Label = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer/nbrAssigned
@onready var nbr_unassigned: Label = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/VBoxContainer/HBoxContainer3/nbrUnassigned
@onready var btn_recruit: Button = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/NinePatchRect/btnRecruit
@onready var animation: AnimationPlayer = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer2/NinePatchRect/btnRecruit/AnimationPlayer


var nbrScientists := 0
var nbrScientistsAssigned := 0
var nbrScientistsUnassigned := 0

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
		_update_recruit_price()

	
func _on_btn_recruit_pressed() -> void:
	if GameController.pay_scientist():
		UiController.emit_enroll_scientist()
		nbr_unassigned.text = str(GameController.get_scientist_total())
		nbrScientists += 1
		nbrScientistsUnassigned += 1
		_update_recruit_price()
	else:
		if not animation.is_playing():
			animation.play("not_enough_credit")
			not_enough_science.emit()

func _on_update_assign_scientist():
	nbrScientistsAssigned += 1
	nbrScientistsUnassigned -= 1
	nbr_assigned.text = str(nbrScientistsAssigned)
	nbr_unassigned.text = str(nbrScientistsUnassigned)

func _on_update_deassign_scientist():
	nbrScientistsAssigned -= 1
	nbrScientistsUnassigned += 1
	nbr_assigned.text = str(nbrScientistsAssigned)
	nbr_unassigned.text = str(nbrScientistsUnassigned)

func _update_recruit_price():
	btn_recruit.text = "Recruter (" + str(int(GameController.scientist_manager.get_scientist_price())) + ")"
