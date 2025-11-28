extends MarginContainer

@export var projectScene : PackedScene

@onready var projet_container: VBoxContainer = $ninePatchRect/VBoxContainer/ScrollContainer/projetContainer


var nbProject = 0;
var nbPage = 1;
var nbPageTot = 1;
var nbProjPerPage = 0;

var arrayProjects = Array()


func _on_prev_pressed() -> void:
	if (nbPage > 1) :
		for proj in arrayProjects :
			proj.setVisibility(false)
			
		nbPage -= 1
		nbProjPerPage = 0
		
		for i in 5 :
			arrayProjects.get(i+5*(nbPage-1)).setVisibility(true)
			nbProjPerPage += 1


func _on_next_pressed() -> void:
	if (nbPage < nbPageTot) :
		for i in 5 :
			arrayProjects.get(i+5*(nbPage-1)).setVisibility(false)
			
		nbPage += 1
		nbProjPerPage = 0
		
		if (nbPage == nbPageTot) :
			for i in nbProject%5 :
				arrayProjects.get(i+5*(nbPage-1)).setVisibility(true)
				nbProjPerPage += 1
		else :
			for i in 5 :
				arrayProjects.get(i+5*(nbPage-1)).setVisibility(true)
				nbProjPerPage += 1


func _on_button_test_pressed() -> void:
	nbProject += 1
	#if (nbProject-1)%5 == 0 and nbProject > 1 :
	#	nbPageTot += 1

	var proj = projectScene.instantiate()
	arrayProjects.append(proj)
	projet_container.add_child(proj)
	
	proj.setName(str(nbProject))
	#proj.setVisibility(false)
	
	proj.setVisibility(true)
	#nbProjPerPage += 1
	
	#if nbProjPerPage < 5 :
	#	proj.setVisibility(true)
	#	nbProjPerPage += 1


func _on_button_test_2_pressed() -> void:
	#if (nbProject > 0) :
	#	if (nbProject-1)%5 == 0 and nbProject > 1 :
	#		nbPageTot -= 1
		
	projet_container.remove_child(arrayProjects.get(nbProject-1))
	arrayProjects.remove_at(nbProject-1)
		
	nbProject -= 1
	#	nbProjPerPage -= 1
	#	if nbProjPerPage == 0 :
	#		nbProjPerPage = 4
	#		nbPageTot -= 1
	#		_on_prev_pressed()
