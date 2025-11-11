extends Area2D
class_name Path

@onready var sprite_2d : Sprite2D = $Sprite2D

@onready var gauche : Area2D = $LinkCollisions/Gauche
@onready var haut : Area2D = $LinkCollisions/Haut
@onready var droite : Area2D = $LinkCollisions/Droite
@onready var bas : Area2D = $LinkCollisions/Bas

@onready var collisions_detected  = {
	"gauche" : false,
	"haut" : false,
	"droite" : false,
	"bas" : false,
}

func _ready():
	remove_child($PreviewTexture)
	for dir in [gauche, haut, droite, bas]:
		dir.area_entered.connect(_on_area_changed)
		dir.area_exited.connect(_on_area_changed)

func _on_area_changed(area):
	_on_update_sprite()

func _on_update_sprite():
	collisions_detected["gauche"] =  check_collision(gauche)
	collisions_detected["haut"] =  check_collision(haut)
	collisions_detected["droite"] =  check_collision(droite)
	collisions_detected["bas"] =  check_collision(bas)
	
	sprite_2d.frame = encode_collisions(collisions_detected)

func check_collision(direction : Area2D) -> bool:
	for paths in direction.get_overlapping_areas():
		if paths.is_class("Area2D"):
			return true
	return false
	
func encode_collisions(collisions: Dictionary) -> int:
	var value := 0
	if collisions.get("gauche", false):
		value |= 1 << 0
	if collisions.get("haut", false):
		value |= 1 << 1
	if collisions.get("droite", false):
		value |= 1 << 2
	if collisions.get("bas", false):
		value |= 1 << 3
	return value

func get_preview() -> Texture2D :
	return get_node_or_null("PreviewTexture").texture
