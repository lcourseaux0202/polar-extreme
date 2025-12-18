extends MarginContainer
## displays the different science buildings (SubMenuAddScientistToBuilding) in a list

@export var BatScene : PackedScene

@onready var bat_container: VBoxContainer = $ninePatchRect/VBoxContainer/ScrollContainer/batContainer


var arrayBats = Array()		## list of SubMenuAddScientistToBuilding


## connects the signal
func _ready() -> void:
	UiController.validate_building_placement.connect(_update_build_list)


## when changed to visible, update the container
func _on_visibility_changed() -> void:
	if visible == true :
		_update_build_list(null)


## removes all the SubMenus, then adds them all back in (not duplicates)
## add all the SubMenus of the science buildings in the list arrayBats
## entry : the new building (Building)
func _update_build_list(new_building : Building) -> void:
	var listBuildings = GameController.get_all_buildings()
	if bat_container :
		for build in bat_container.get_children() :
			bat_container.remove_child(build)
		
	for build : Building in listBuildings :
		if build.building_genre == Enums.BUILDING_GENRE.SCIENCE:
			add_bat_to_list(build)
	if new_building:
		if new_building.building_genre == Enums.BUILDING_GENRE.SCIENCE:
			add_bat_to_list(new_building)


## create a SubMenu for the building
## entry : the building (Building)
func add_bat_to_list(building : Building) -> void:
	var Bat := BatScene.instantiate()
		
	arrayBats.append(Bat)
	bat_container.add_child(Bat)
	
	Bat.setBuilding(building)
	Bat.setName(building.building_name)
	Bat.setVisibility(true)
