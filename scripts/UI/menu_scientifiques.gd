extends MarginContainer

@onready var menu_assignation_scientifiques: MarginContainer = $HBoxContainer/MenuAssignationScientifiques


func _on_button_pressed() -> void:
	if (!menu_assignation_scientifiques.visible):
		menu_assignation_scientifiques.visible = true
	else:
		menu_assignation_scientifiques.visible = false


func _on_visibility_changed() -> void:
	if visible:
		menu_assignation_scientifiques.visible = false
