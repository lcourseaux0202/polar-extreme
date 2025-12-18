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
	if GameController.enough_scientist_for_assignement(project.requirement_scientists):
		var proj := projectScene.instantiate()
		project_container.add_child(proj)
		proj.setProject(project)
		proj.instanciateProject()
		proj.startProject()
		proj.setVisibility(true)
		arrayProjects.append(proj)	


##
##update notification indicator
func _process(delta: float) -> void:
	var i := 0
	for proj in arrayProjects :
		var project : Project = proj.getProject()
		if project.get_project_state() == 3 :
			i += 1
	if(i>0):
		notif.set_text(str(i))
		notif.setVisible(true)
	else:
		notif.set_text(str(0))
		notif.setVisible(false)


## closes projects that have ended
func _on_btn_close_projects_pressed() -> void:
	var arrayTemp : Array
	for proj in arrayProjects :
		var project : Project = proj.getProject()
		if project.get_project_state() == 3 :
			proj.setVisibility(false)
			project_container.remove_child(proj)
			arrayTemp.append(proj)
	for proj in arrayTemp :
		arrayProjects.erase(proj)
	print(arrayProjects)
