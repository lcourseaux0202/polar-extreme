extends MarginContainer
## displays the different projects started and allows the player to close them once finished

@export var projectScene : PackedScene

@onready var notif : NotificationIndicator = $"../projScienMenu/vBoxBtns/btnProjets/NotifProject"
@onready var project_container: VBoxContainer = $ninePatchRect/VBoxContainer/MarginContainer/ScrollContainer/projectContainer


var arrayProjects : Array		## list of SubMenuProjects


## connects the signal
func _ready() -> void:
	notif.setVisible(false);
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


func _process(delta: float) -> void:
	var finished_count := 0

	for proj in arrayProjects:
		var proje :Project = proj.project
		print(proje.get_project_state())
		if proje.get_project_state() >= 3:
			finished_count += 1
	if(finished_count>0):
		notif.set_text(str(finished_count))
	else:
		notif.setVisible(false)
## closes projects that have ended
func _on_btn_close_projects_pressed() -> void:
	var i := 0
	var arrayIndex : Array[int]
	for proj in arrayProjects :
		var project : Project = proj.getProject()
		if project.get_project_state() == 3 :
			proj.setVisibility(false)
			project_container.remove_child(proj)
			arrayIndex.append(proj)
		i += 1
	for proj in arrayIndex :
		arrayProjects.erase(proj)
