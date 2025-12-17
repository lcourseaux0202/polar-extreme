extends MarginContainer

@export var projectScene : PackedScene

@onready var menu_batiment: MarginContainer = $"."

@onready var lbl_name: Label = $NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/lblName
@onready var projet_container: VBoxContainer = $NinePatchRect/VBoxContainer/VBoxContainer/ScrollContainer/projetContainer

@onready var lbl_desc: Label = $NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/lblDesc
@onready var pop_desc_building: Popup = $popDescBuilding
@onready var lbl_nbr: Label = $NinePatchRect/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/lblNbr

var buil : Building

var project_menu_list : Array
var project_list : Array[Project]


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	UiController.click_on_building.connect(_on_click_on_building)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_click_on_building(building : Building):
	menu_batiment.visible = true
	buil = building
	
	lbl_name.text = building.get_building_name()
	lbl_desc.text = GameController.get_building_description(building.building_type)
	
	if buil.building_genre == Enums.BUILDING_GENRE.SCIENCE and buil.has_method("get_nbr_scientist"):
		lbl_nbr.text = str(buil.get_nbr_scientist()) + "/" + str(buil.get_nbr_scientist_max())
	
		for proj in projet_container.get_children() :
			projet_container.remove_child(proj)
				
		#var listeBuildings = GameController.building_manager.get_building_list()
		
		project_menu_list = building.get_project_list()

		for project in project_menu_list :
			var proj = projectScene.instantiate()
			projet_container.add_child(proj)
			proj.setProject(project)
			proj.instanciateProject()
			proj.setVisibility(true)
			project_list.append(proj)


func _on_btn_expl_pressed() -> void:
	pop_desc_building.visible = true
	pop_desc_building.setDesc(buil.building_description)


func _on_btn_add_pressed() -> void:
	if GameController.scientist_manager.enough_scientist_for_assignement(1):
		if (buil.building_genre == Enums.BUILDING_GENRE.SCIENCE):
			if buil.add_scientist():
				UiController.emit_assign_scientist()
				lbl_nbr.text = str(buil.get_nbr_scientist()) + "/" + str(buil.get_nbr_scientist_max())


func _on_btn_rem_pressed() -> void:
	if (buil.building_genre == Enums.BUILDING_GENRE.SCIENCE):
		if buil.remove_scientist() :
			UiController.emit_deassign_scientist()
			lbl_nbr.text = str(buil.get_nbr_scientist()) + "/" + str(buil.get_nbr_scientist_max())


func _on_btn_quit_pressed() -> void:
	menu_batiment.visible = false
