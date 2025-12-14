extends MarginContainer

@onready var menu_assignation_scientifiques: MarginContainer = $HBoxContainer/MenuAssignationScientifiques
@onready var nbr_assigned: Label = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/nbrAssigned
@onready var nbr_unassigned: Label = $HBoxContainer/MarginContainer/ninePatchRect/MarginContainer/VBoxContainer/HBoxContainer3/nbrUnassigned

var nbrScientists := 0
var nbrScientistsAssigned := 0
var nbrScientistsUnassigned := 0

func _ready() -> void:
	UiController.update_assign_scientist.connect(_on_update_assign_scientist)
	UiController.update_deassign_scientist.connect(_on_update_deassign_scientist)


func _on_button_pressed() -> void:
	if (!menu_assignation_scientifiques.visible):
		menu_assignation_scientifiques.visible = true
	else:
		menu_assignation_scientifiques.visible = false


func _on_visibility_changed() -> void:
	if visible:
		menu_assignation_scientifiques.visible = false


func _on_btn_recruit_pressed() -> void:
	UiController.emit_enroll_scientist()
	nbr_unassigned.text = str(GameController.get_scientist_total())
	nbrScientists += 1
	nbrScientistsUnassigned += 1

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
