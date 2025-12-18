extends MarginContainer

@export var projectScene : PackedScene

@onready var project_container: VBoxContainer = $ninePatchRect/VBoxContainer/ScrollContainer/projectContainer


var arrayProjects : Array


func _ready() -> void:
	UiController.start_project.connect(_on_start_project)


func _on_visibility_changed() -> void:
	pass
	#if visible == true :
		
		#for proj in projet_container.get_children() :
			#projet_container.remove_child(proj)
			#
		#var listeBuildings = GameController.building_manager.get_building_list()
		#
		#for building : Building in listeBuildings :
			#if building.has_method("get_project_list") :
				#var liste = building.get_project_list()
		#
				#for project : Project in liste :
					#var proj = projectScene.instantiate()
					#projet_container.add_child(proj)
					#proj.setName(project.get_project_name())
					#proj.setStatus(project.get_project_state())
					#proj.setProject(project)
					#proj.setVisibility(true)

func _on_start_project(project : Project) -> void:
	var proj := projectScene.instantiate()
	project_container.add_child(proj)
	proj.setProject(project)
	proj.instanciateProject()
	proj.startProject()
	proj.setVisibility(true)
	arrayProjects.append(proj)
