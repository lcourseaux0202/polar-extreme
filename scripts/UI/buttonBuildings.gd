extends Control

class_name buttonBuildings


# exports (permet de modifier pour chaque bouton) et autres vars
@export var textBuildingName : String
@export var textPopup : String
@export var icon_pos : Vector2		# commence à (0,0)

@onready var button: Button = $VBoxContainer/Button
@onready var label: Label = $VBoxContainer/Control/NinePatchRect/MarginContainer/Label
@onready var nine_patch_rect: NinePatchRect = $VBoxContainer/Control/NinePatchRect

var alreadyCliked := false

# methodes
func set_button_iconn() -> void:
	var atlas := AtlasTexture.new()
	atlas.atlas = preload("res://assets/UI/tilesetT3.png")
	atlas.region = Rect2(icon_pos * Vector2(64, 64), Vector2(64, 64))

	button.icon = atlas
	


func _ready() -> void:
	label.text = textBuildingName
	set_button_iconn()


func _on_button_mouse_entered() -> void:
	nine_patch_rect.visible = true


func _on_button_mouse_exited() -> void:
	nine_patch_rect.visible = false


func _on_button_pressed() -> void:
	if !alreadyCliked :
		alreadyCliked = true
		afficherPopup()
		_on_button_pressed()
	else :
		label.text = "ta mere"


func afficherPopup() -> void :
	var popup := Popup.new()
	popup.add_child(Label.new())
	popup.get_child(0).text = textPopup
	add_child(popup)
	popup.popup_centered()
