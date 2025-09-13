@tool
@icon("res://assets/icon/building_icon.svg")
extends Area2D
class_name BaseBuilding


@onready var sprite: Sprite2D = $building_sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	if not sprite:
		push_error("BaseBuilding nécessite un Sprite2D assigné !")
	if not collision_shape:
		push_error("BaseBuilding nécessite un CollisionShape2D assigné !")


func init(_pos : Vector2) -> void:
	z_index = 4
	position = _pos
	
