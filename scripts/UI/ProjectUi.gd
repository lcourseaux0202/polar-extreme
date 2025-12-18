extends MarginContainer
## displays the different projects started and allows the player to close them once finished

@export var projectScene : PackedScene

@onready var project_container: VBoxContainer = $ninePatchRect/VBoxContainer/ScrollContainer/projectContainer


var arrayProjects : Array		## list of SubMenuProjects


## connects the signal
func _ready() -> void:
	UiController.start_project.connect(_on_start_project)


## create a new SubMenuProjects for the project started
## entry : the project (Project)
func _on_start_project(project : Project) -> void:
	var proj := projectScene.instantiate()
	project_container.add_child(proj)
	proj.setProject(project)
	proj.instanciateProject()
	proj.startProject()
	proj.setVisibility(true)
	arrayProjects.append(proj)
