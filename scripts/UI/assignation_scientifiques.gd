extends MarginContainer

@onready var nom: Label = $MarginContainer/nine/MarginContainer/HBoxContainer/nom
@onready var nombre_scient: Label = $MarginContainer/nine/MarginContainer/HBoxContainer/nombreScient


var buil : Building

func setName(text : String) :
	nom.text = text

func setVisibility(vis : bool) :
	visible = vis

func setBuiliding(building : Building) :
	buil = building
	nombre_scient.text = str(buil.get_scientist_number()) + "/" + str(buil.get_max_scientist_number())

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	pass


func _on_assignation_pressed() -> void:
	if GameController.scientist_manager.enough_scientist_for_assignement(1):
		if buil.add_scientist() :
			UiController.emit_assign_scientist()
			nombre_scient.text = str(buil.get_scientist_number()) + "/" + str(buil.get_max_scientist_number())

func _on_desassignation_pressed() -> void:
	if buil.remove_scientist() :
		UiController.emit_deassign_scientist()
		nombre_scient.text = str(buil.get_scientist_number()) + "/" + str(buil.get_max_scientist_number())
