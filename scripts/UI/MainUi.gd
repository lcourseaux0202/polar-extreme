extends Control
## the main menu of UI

@onready var lbl_science = $hBoxScience/NinePatchRect/lblScience
@onready var lbl_science_per_sec = $hBoxScience/SciencePerSec/lblSciencePerSec

@onready var menu_projects: MarginContainer = $hBoxProjScien/MenuProjects
@onready var menu_scientists: ScientistMenu = $hBoxProjScien/menuScientifics
@onready var animation: AnimationPlayer = $hBoxScience/NinePatchRect/lblScience/AnimationPlayer

@onready var h_box_btns: HBoxContainer = $buildingsMenu/hBoxBtns
@onready var h_box_btn_cat_1: HBoxContainer = $buildingsMenu/hBoxBtnCat1
@onready var h_box_btn_cat_2: HBoxContainer = $buildingsMenu/hBoxBtnCat2
@onready var h_box_btn_cat_3: HBoxContainer = $buildingsMenu/hBoxBtnCat3

@onready var menu_building: MarginContainer = $MenuBuilding
@onready var sub_menu_show_project_infos: MarginContainer = $SubMenuShowProjectInfos

@onready var lbl_buildings_basic_info: Label = $lblBuildingsBasicInfo


## connects the signals and initialises the labels
func _ready() -> void:
	UiController.ui_change_category.connect(_handle_category_changed)
	UiController.science_changed.connect(_on_science_changed)
	UiController.science_second_changed.connect(_on_science_second_changed)
	UiController.display_building_basic_info.connect(_on_display_building_basic_info)
	UiController.start_building.connect(_show_keybinds)
	UiController.validate_building_placement.connect(_hide_keybinds)
	menu_scientists.not_enough_science.connect(_on_not_enough_science)
	lbl_science.text = "0"
	lbl_science_per_sec.text = "0 / sec"
	Input.set_custom_mouse_cursor(load("res://assets/cursor/ice_link.png"),Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(load("res://assets/cursor/Ice-normal.png"),Input.CURSOR_ARROW)


## opens the MenuProjects and closes everything else
func _on_button_projets_pressed() -> void:
	if (!menu_projects.visible):
		menu_projects.visible = true
		menu_scientists.visible = false
		menu_building.visible = false
		sub_menu_show_project_infos.visible = false
	else:
		menu_projects.visible = false


## opens the MenuScientists and closes everything else
func _on_button_scientists_pressed() -> void:
	if (!menu_scientists.visible):
		menu_scientists.visible = true
		menu_projects.visible = false
		menu_building.visible = false
		sub_menu_show_project_infos.visible = false
	else:
		menu_scientists.visible = false


## updates the science value in the label
## entry : science value (float)
func _on_science_changed(new_science : float) ->void:
	if(new_science > 1000000000):
		new_science = new_science / 1000000000
		lbl_science.text = str(round(new_science * 10.0) / 10.0) + " B"
	elif (new_science > 1000000):
		new_science = new_science / 1000000
		lbl_science.text = str(round(new_science * 10.0) / 10.0) + " M"
	elif(new_science > 1000):
		new_science = new_science / 1000
		lbl_science.text = str(round(new_science * 10.0) / 10.0) + " K"
	else :
		var science_int : int = int(new_science)
		lbl_science.text = str(science_int)


## updates the science value per second in the label
## entry : science value (float)
func _on_science_second_changed(new_science) ->void:
	if(new_science > 1000000000):
		new_science = new_science / 1000000000
		lbl_science_per_sec.text = str(round(new_science * 10.0) / 10.0) + " B / sec"
	elif (new_science > 1000000):
		new_science = new_science / 1000000
		lbl_science_per_sec.text = str(round(new_science * 10.0) / 10.0) + " M / sec"
	elif(new_science > 1000):
		new_science = new_science / 1000
		lbl_science_per_sec.text = str(round(new_science * 10.0) / 10.0) + " K / sec"
	else :
		var science_int : int = int(new_science)
		lbl_science_per_sec.text = str(science_int) + " / sec"


## displays the buildings basic infos when hovering the buildings
## entry : the building (Building)
func _on_display_building_basic_info(building: Building) -> void:
	lbl_buildings_basic_info.add_theme_color_override("font_color", Color.BLACK)
	lbl_buildings_basic_info.remove_theme_color_override("font_shadow_color")
	if building:
		lbl_buildings_basic_info.text = building.building_name
		if(building.has_method("get_science_production")):
			if building.get_science_production() > 0:
				lbl_buildings_basic_info.text += "\n" + str(building.get_science_production()) + " /sec"
				var new_color : Color = Color(1.0,0.0,0.0)
				new_color.r -= building.get_science_production_ratio()
				new_color.g += building.get_science_production_ratio()
				lbl_buildings_basic_info.add_theme_color_override("font_color", new_color)
				lbl_buildings_basic_info.add_theme_color_override("font_shadow_color", Color.WHEAT)
			else :
				lbl_buildings_basic_info.text += "\nAucune production : assignez des scientifiques pour lancer la production..."
		lbl_buildings_basic_info.show()
	else:
		lbl_buildings_basic_info.hide()


## displays the keybinds when placing a building
## entry : the building (Building) (not used -> _)
func _show_keybinds(_building : Building) -> void:
	lbl_buildings_basic_info.remove_theme_color_override("font_shadow_color")
	lbl_buildings_basic_info.add_theme_color_override("font_color", Color.BLACK)
	lbl_buildings_basic_info.text = "R pour pivoter     Clic droit pour placer"
	lbl_buildings_basic_info.show()


## plays an animation when there isn't enough science
func _on_not_enough_science() -> void:
	animation.play("not_enough_credit")

func _hide_keybinds(_building : Building):
	lbl_buildings_basic_info.hide()

#func _on_button_assigner_scientists_pressed() -> void:
	#pass

#func _on_btn_path_pressed() -> void:
	#pass # Replace with function body.


## calls another function that changes the buttons displayed
## entry : the number of the category to display (int)
func _handle_category_changed(cat_num : int) -> void:
	match cat_num:
		1:
			btn_cat_1_pressed()
		2:
			btn_cat_2_pressed()
		3:
			btn_cat_3_pressed()


## shows the buttons from the 1st category
func btn_cat_1_pressed() -> void:
	h_box_btn_cat_1.visible = true
	h_box_btn_cat_2.visible = false
	h_box_btn_cat_3.visible = false
	h_box_btns.visible = false
	

## shows the buttons from the 2nd category
func btn_cat_2_pressed() -> void:
	h_box_btn_cat_1.visible = false
	h_box_btn_cat_2.visible = true
	h_box_btn_cat_3.visible = false
	h_box_btns.visible = false


## shows the buttons from the 3rd category
func btn_cat_3_pressed() -> void:
	h_box_btn_cat_1.visible = false
	h_box_btn_cat_2.visible = false
	h_box_btn_cat_3.visible = true
	h_box_btns.visible = false


## shows the buttons from the main category
func _on_btn_back_pressed() -> void:
	h_box_btn_cat_1.visible = false
	h_box_btn_cat_2.visible = false
	h_box_btn_cat_3.visible = false
	h_box_btns.visible = true


## shows the settings
func _on_parameters_pressed() -> void:
	SettingsValue.open()
