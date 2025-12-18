extends Control

class_name buttonCategory


# exports (permet de modifier pour chaque bouton) et autres vars
@export var textBuildingName : String
@export var textPopup : String
@export var icon_pos : Vector2		# commence à (0,0)

@onready var btn_crea_building: Button = $VBoxContainer/btnCreaBuilding
@onready var lbl_desc: Label = $VBoxContainer/Control/NinePatchRect/MarginContainer/lblDesc
@onready var nine_patch_rect: NinePatchRect = $VBoxContainer/Control/NinePatchRect
@onready var popup: Popup = $Popup

@export_range(1,3) var category : int

var alreadyCliked := false

# methodes
func set_button_icon_nor() -> void:
	var atlas := AtlasTexture.new()
	atlas.atlas = preload("res://assets/UI/tilesetT3.png")
	atlas.region = Rect2(icon_pos * Vector2(64, 64), Vector2(64, 64))

	btn_crea_building.icon = atlas
	
func set_button_icon_pressed() -> void:
	var atlas := AtlasTexture.new()
	atlas.atlas = preload("res://assets/UI/tilesetT3_pressed.png")
	atlas.region = Rect2(icon_pos * Vector2(64, 64), Vector2(64, 64))

	btn_crea_building.icon = atlas

func set_button_icon_hovered() -> void:
	var atlas := AtlasTexture.new()
	atlas.atlas = preload("res://assets/UI/tilesetT3_hovered.png")
	atlas.region = Rect2(icon_pos * Vector2(64, 64), Vector2(64, 64))

	btn_crea_building.icon = atlas
	


func _ready() -> void:
	lbl_desc.text = textBuildingName
	set_button_icon_nor()


func _on_button_mouse_entered() -> void:
	set_button_icon_hovered()
	nine_patch_rect.visible = true


func _on_button_mouse_exited() -> void:
	set_button_icon_nor()
	nine_patch_rect.visible = false


func _on_button_pressed() -> void:
	set_button_icon_pressed()
	UiController.emit_change_category(category)
	UiController.stop_building_path.emit()
	set_button_icon_nor()


func afficherPopup() -> void :
	popup.visible = true
	popup.setDesc(textPopup)
