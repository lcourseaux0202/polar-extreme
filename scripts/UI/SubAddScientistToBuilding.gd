extends MarginContainer
## allows to add and remove scientists from a building

@onready var nom: Label = $MarginContainer/nine/MarginContainer/HBoxContainer/nom
@onready var nombre_scient: Label = $MarginContainer/nine/MarginContainer/HBoxContainer/nombreScient
@onready var audio: AudioStreamPlayer2D = $MarginContainer/nine/MarginContainer/HBoxContainer/assignation/AudioStreamPlayer2D


var buil : Building


## sets the name of the building
## entry : the name (String)
func setName(text : String) :
	nom.text = text


## change the visibility of the menu
## entry : the visibility to have (bool)
func setVisibility(vis : bool) :
	visible = vis


## set the building and update the number of scientist displayed
## entry : the building (Building)
func setBuilding(building : Building) :
	buil = building
	
	if (buil.building_genre == Enums.BUILDING_GENRE.SCIENCE):
		nombre_scient.text = str(buil.get_nbr_scientist()) + "/" + str(buil.get_nbr_scientist_max())


func _process(delta: float) -> void:
	pass

func _ready() -> void:
	pass


## add a scientist
func _on_assignation_pressed() -> void:
	if GameController.scientist_manager.enough_scientist_for_assignement(1):
		if (buil.building_genre == Enums.BUILDING_GENRE.SCIENCE):
			if buil.add_scientist():
				UiController.emit_assign_scientist()
				nombre_scient.text = str(buil.get_nbr_scientist()) + "/" + str(buil.get_nbr_scientist_max())
	else :
		audio.play()


## remove a scientist
func _on_desassignation_pressed() -> void:
	if (buil.building_genre == Enums.BUILDING_GENRE.SCIENCE):
		if buil.remove_scientist() :
			UiController.emit_deassign_scientist()
			nombre_scient.text = str(buil.get_nbr_scientist()) + "/" + str(buil.get_nbr_scientist_max())
