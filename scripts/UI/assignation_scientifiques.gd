extends MarginContainer

@onready var nom: Label = $MarginContainer/nine/MarginContainer/HBoxContainer/nom
@onready var nombre_scient: Label = $MarginContainer/nine/MarginContainer/HBoxContainer/nombreScient

var ID

var nombreScientifiques = 0

func setName(text : String) :
	nom.text = text
	ID = int(text)

func setVisibility(vis : bool) :
	visible = vis

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	pass



func _on_assignation_pressed() -> void:
	nombreScientifiques += 1
	nombre_scient.text = str(nombreScientifiques)


func _on_desassignation_pressed() -> void:
	if nombreScientifiques > 0:
		nombreScientifiques -= 1
		nombre_scient.text = str(nombreScientifiques)
