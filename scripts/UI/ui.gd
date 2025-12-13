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


func _ready() -> void:
	UiController.connect("ui_change_category", _handle_category_changed)
	UiController.connect("science_changed", _on_science_changed)
	UiController.connect("science_second_changed", _on_science_second_changed)
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



func _on_science_changed() ->void:
	lbl_science.text = str(GameController.gauges.get_science())


func _on_science_second_changed() ->void:
	lbl_science_per_sec.text = str(GameController.gauges.get_science_per_second()) + "/sec"


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
