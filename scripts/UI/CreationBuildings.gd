extends Control

class_name buttonBuildings


# exports (permet de modifier pour chaque bouton) et autres vars
@export var textBuildingName : String
@export var icon_pos : Vector2		# commence à (0,0)
@export var btype : Enums.BUILDING_TYPE

@onready var nine_patch_rect: NinePatchRect = $VBoxContainer/Control/NinePatchRect
@onready var popup: Popup = $Popup

@onready var btn_crea_building: Button = $VBoxContainer/btnCreaBuilding
@onready var lbl_desc: Label = $VBoxContainer/Control/NinePatchRect/MarginContainer/lblDesc
@onready var notif : NotificationIndicator = $NotificationIndicator

@export var building_path : String
var building_scene
var building_instance
var is_buyable:bool


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
	
func _process(delta: float) -> void:
	if building_scene:
		is_buyable = building_instance.price <= GameController.get_gauges().science
		btn_crea_building.disabled = !is_buyable
		notif.setVisible(is_buyable)

func _ready() -> void:
	set_button_icon_nor()
	if not building_path.is_empty():
		building_scene = load(building_path)
		building_instance = building_scene.instantiate()
		lbl_desc.text = textBuildingName + "\n(Coût : " + str(building_instance.price) + ")"
	

func _on_button_mouse_entered() -> void:
	set_button_icon_hovered()
	nine_patch_rect.visible = true

func _on_button_mouse_exited() -> void:
	set_button_icon_nor()
	nine_patch_rect.visible = false

func _on_button_pressed() -> void:
	set_button_icon_pressed()
	UiController.emit_build_batiment(btype)
	set_button_icon_nor()

func afficherPopup() -> void :
	popup.visible = true
	popup.setDesc(GameController.get_building_description(btype))
