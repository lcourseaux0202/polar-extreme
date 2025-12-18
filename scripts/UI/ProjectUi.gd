extends MarginContainer
## displays the different projects started and allows the player to close them once finished

@export var projectScene : PackedScene

@onready var notif : NotificationIndicator = $"../projScienMenu/vBoxBtns/btnProjets/NotifProject"
@onready var project_container: VBoxContainer = $ninePatchRect/VBoxContainer/MarginContainer/ScrollContainer/projectContainer
@onready var nine_icon: NinePatchRect = $ninePatchRect/VBoxContainer/nineIcon

var arrayProjects : Array		## list of SubMenuProjects

@export var icon_normal: Texture2D
@export var icon_pressed: Texture2D
@export var icon_hover: Texture2D

## connects the signal
func _ready() -> void:
	nine_icon.texture = icon_normal
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10
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
		nine_icon.visible = true
		notif.set_text(str(i))
		notif.setVisible(true)
	else:
		nine_icon.visible = false
		notif.set_text(str(0))
		notif.setVisible(false)


## closes projects that have ended
func _on_btn_close_projects_pressed() -> void:
	nine_icon.texture = icon_pressed
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10
	var arrayTemp : Array
	for proj in arrayProjects :
		var project : Project = proj.getProject()
		if project.get_project_state() == 3 :
			proj.setVisibility(false)
			project_container.remove_child(proj)
			arrayTemp.append(proj)
	for proj in arrayTemp :
		arrayProjects.erase(proj)
	#print(arrayProjects)
	nine_icon.texture = icon_normal


## change the icon of the button
func _on_btn_close_projects_mouse_entered() -> void:
	nine_icon.texture = icon_hover
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10

## change the icon of the button
func _on_btn_close_projects_mouse_exited() -> void:
	nine_icon.texture = icon_normal
	nine_icon.patch_margin_bottom = 10
	nine_icon.patch_margin_left = 10
	nine_icon.patch_margin_right = 10
	nine_icon.patch_margin_top = 10
