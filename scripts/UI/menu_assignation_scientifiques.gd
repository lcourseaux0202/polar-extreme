extends MarginContainer

@export var BatScene : PackedScene

@onready var bat_container: VBoxContainer = $ninePatchRect/VBoxContainer/ScrollContainer/batContainer

var nbBat = 0;
var nbPage = 1;
var nbPageTot = 1;
var nbBatPerPage = 0;

var arrayBats = Array()





#func _on_button_test_pressed() -> void:
	#nbBat += 1
	#if (nbBat-1)%5 == 0 and nbBat > 1 :
		#nbPageTot += 1
#
	#var Bat = BatScene.instantiate()
	#arrayBats.append(Bat)
	#bat_container.add_child(Bat)
	#
	#Bat.setName(str(nbBat))
	#Bat.setVisibility(false)
	#
	#if nbBatPerPage < 5 :
		#Bat.setVisibility(true)
		#nbBatPerPage += 1
#
#
#func _on_button_test_2_pressed() -> void:
	#if (nbBat > 0) :
		#if (nbBat-1)%5 == 0 and nbBat > 1 :
			#nbPageTot -= 1
		#
		#bat_container.remove_child(arrayBats.get(nbBat-1))
		#arrayBats.remove_at(nbBat-1)
		#
		#nbBat -= 1
		#nbBatPerPage -= 1
		#if nbBatPerPage == 0 :
			#nbBatPerPage = 4
			#nbPageTot -= 1


func _on_visibility_changed() -> void:
	if visible == true :
		var listBuildings = GameController.get_all_buildings()
		if bat_container :
			for build in bat_container.get_children() :
				bat_container.remove_child(build)
			
		for build in listBuildings :
			var Bat := BatScene.instantiate()
			
			arrayBats.append(Bat)
			bat_container.add_child(Bat)
			
			Bat.setBuiliding(build)
			Bat.setName(build.building_name)
			Bat.setVisibility(true)
			
