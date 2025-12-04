extends MarginContainer

@export var BatScene : PackedScene

@onready var bat_container: VBoxContainer = $ninePatchRect/VBoxContainer/ScrollContainer/batContainer

var nbBat = 0;
var nbPage = 1;
var nbPageTot = 1;
var nbBatPerPage = 0;

var arrayBats = Array()



func _on_prev_pressed() -> void:
	if (nbPage > 1) :
		for proj in arrayBats :
			proj.setVisibility(false)
			
		nbPage -= 1
		nbBatPerPage = 0
		
		for i in 5 :
			arrayBats.get(i+5*(nbPage-1)).setVisibility(true)
			nbBatPerPage += 1


func _on_next_pressed() -> void:
	if (nbPage < nbPageTot) :
		for i in 5 :
			arrayBats.get(i+5*(nbPage-1)).setVisibility(false)
			
		nbPage += 1
		nbBatPerPage = 0
		
		if (nbPage == nbPageTot) :
			for i in nbBat%5 :
				arrayBats.get(i+5*(nbPage-1)).setVisibility(true)
				nbBatPerPage += 1
		else :
			for i in 5 :
				arrayBats.get(i+5*(nbPage-1)).setVisibility(true)
				nbBatPerPage += 1


func _on_button_test_pressed() -> void:
	nbBat += 1
	if (nbBat-1)%5 == 0 and nbBat > 1 :
		nbPageTot += 1

	var Bat = BatScene.instantiate()
	arrayBats.append(Bat)
	bat_container.add_child(Bat)
	
	Bat.setName(str(nbBat))
	Bat.setVisibility(false)
	
	if nbBatPerPage < 5 :
		Bat.setVisibility(true)
		nbBatPerPage += 1


func _on_button_test_2_pressed() -> void:
	if (nbBat > 0) :
		if (nbBat-1)%5 == 0 and nbBat > 1 :
			nbPageTot -= 1
		
		bat_container.remove_child(arrayBats.get(nbBat-1))
		arrayBats.remove_at(nbBat-1)
		
		nbBat -= 1
		nbBatPerPage -= 1
		if nbBatPerPage == 0 :
			nbBatPerPage = 4
			nbPageTot -= 1
			_on_prev_pressed()
