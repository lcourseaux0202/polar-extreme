extends Control
# https://www.kodeco.com/45869762-making-responsive-ui-in-godot/
# https://kidscancode.org/godot_recipes/4.x/ui/level_select/index.html

@onready var menu_projects: MarginContainer = $BaseContainer/hBoxProjScien/MenuProjects
@onready var menu_scientists: MarginContainer = $BaseContainer/hBoxProjScien/menuScientifics

@onready var h_box_btns: HBoxContainer = $BaseContainer/buildingsMenu/hBoxBtns
@onready var h_box_btn_cat_1: HBoxContainer = $BaseContainer/buildingsMenu/hBoxBtnCat1
@onready var h_box_btn_cat_2: HBoxContainer = $BaseContainer/buildingsMenu/hBoxBtnCat2
@onready var h_box_btn_cat_3: HBoxContainer = $BaseContainer/buildingsMenu/hBoxBtnCat3

func _ready() -> void:
	UiController.connect("ui_change_category", _handle_category_changed)

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


func _on_button_assigner_scientists_pressed() -> void:
	pass



func _on_btn_path_pressed() -> void:
	pass # Replace with function body.

func _handle_category_changed(cat_num : int) :
	match cat_num:
		1:
			_on_btn_cat_1_pressed()
		2:
			_on_btn_cat_2_pressed()
		3:
			_on_btn_cat_3_pressed()

func _on_btn_cat_1_pressed() -> void:
	h_box_btn_cat_1.visible = true
	h_box_btn_cat_2.visible = false
	h_box_btn_cat_3.visible = false
	h_box_btns.visible = false
	

func _on_btn_cat_2_pressed() -> void:
	h_box_btn_cat_1.visible = false
	h_box_btn_cat_2.visible = true
	h_box_btn_cat_3.visible = false
	h_box_btns.visible = false


func _on_btn_cat_3_pressed() -> void:
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


#func _on_btn_path_mouse_entered() -> void:
	#var test = Label.new()
	#test.text = "TEST"
	#test.visible = true
	#add_child(test)
