extends Control
# https://www.kodeco.com/45869762-making-responsive-ui-in-godot/
# https://kidscancode.org/godot_recipes/4.x/ui/level_select/index.html

@onready var lbl_science = $hBoxScience/NinePatchRect/lblScience
@onready var lbl_science_per_sec = $hBoxScience/SciencePerSec/lblSciencePerSec

@onready var menu_projects: MarginContainer = $hBoxProjScien/MenuProjects
@onready var menu_scientists: MarginContainer = $hBoxProjScien/menuScientifics

@onready var h_box_btns: HBoxContainer = $buildingsMenu/hBoxBtns
@onready var h_box_btn_cat_1: HBoxContainer = $buildingsMenu/hBoxBtnCat1
@onready var h_box_btn_cat_2: HBoxContainer = $buildingsMenu/hBoxBtnCat2
@onready var h_box_btn_cat_3: HBoxContainer = $buildingsMenu/hBoxBtnCat3

@onready var lbl_buildings_basic_info: Label = $lblBuildingsBasicInfo

func _ready() -> void:
	UiController.ui_change_category.connect(_handle_category_changed)
	UiController.science_changed.connect(_on_science_changed)
	UiController.science_second_changed.connect(_on_science_second_changed)
	UiController.display_building_basic_info.connect(_on_display_building_basic_info)
	UiController.start_building.connect(_show_keybinds)
	UiController.validate_building_placement.connect(_hide_keybinds)
	lbl_science.text = "0"
	lbl_science_per_sec.text = "0/sec"

# projScienMenu

func _on_button_projets_pressed() -> void:
	if (!menu_projects.visible):
		menu_projects.visible = true
		menu_scientists.visible = false
	else:
		menu_projects.visible = false


func _on_button_scientists_pressed() -> void:
	if (!menu_scientists.visible):
		menu_scientists.visible = true
		menu_projects.visible = false
	else:
		menu_scientists.visible = false



func _on_science_changed(new_science : float) ->void:
	var science_int : int = int(new_science)
	lbl_science.text = str(science_int)


func _on_science_second_changed(new_science) ->void:
	lbl_science_per_sec.text = str(new_science) + "/sec"

func _on_display_building_basic_info(building: Building):
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
				print(new_color)
				lbl_buildings_basic_info.add_theme_color_override("font_color", new_color)
				lbl_buildings_basic_info.add_theme_color_override("font_shadow_color", Color.WHEAT)
			else :
				lbl_buildings_basic_info.text += "\nAucune production : assignez des scientifiques pour lancer la production..."
		lbl_buildings_basic_info.show()
	else:
		lbl_buildings_basic_info.hide()

func _show_keybinds(_building : Building):
	lbl_buildings_basic_info.remove_theme_color_override("font_shadow_color")
	lbl_buildings_basic_info.add_theme_color_override("font_color", Color.WHEAT)
	lbl_buildings_basic_info.text = "R pour pivoter     Clic droit pour placer"
	lbl_buildings_basic_info.show()

func _hide_keybinds(_building : Building):
	lbl_buildings_basic_info.hide()

#func _on_button_assigner_scientists_pressed() -> void:
	#pass

#func _on_btn_path_pressed() -> void:
	#pass # Replace with function body.

func _handle_category_changed(cat_num : int) :
	match cat_num:
		1:
			btn_cat_1_pressed()
		2:
			btn_cat_2_pressed()
		3:
			btn_cat_3_pressed()

func btn_cat_1_pressed() -> void:
	h_box_btn_cat_1.visible = true
	h_box_btn_cat_2.visible = false
	h_box_btn_cat_3.visible = false
	h_box_btns.visible = false
	

func btn_cat_2_pressed() -> void:
	h_box_btn_cat_1.visible = false
	h_box_btn_cat_2.visible = true
	h_box_btn_cat_3.visible = false
	h_box_btns.visible = false


func btn_cat_3_pressed() -> void:
	h_box_btn_cat_1.visible = false
	h_box_btn_cat_2.visible = false
	h_box_btn_cat_3.visible = true
	h_box_btns.visible = false


func _on_btn_remove_pressed() -> void:
	pass # Replace with function body.


func _on_btn_back_pressed() -> void:
	h_box_btn_cat_1.visible = false
	h_box_btn_cat_2.visible = false
	h_box_btn_cat_3.visible = false
	h_box_btns.visible = true
