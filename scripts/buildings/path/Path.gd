extends Area2D
class_name Path

@onready var sprite_2d : Sprite2D = $Sprite2D

func _on_left_area_entered(area: Area2D) -> void:
	$BlockSprites/Left.visible = false

func _on_haut_area_entered(area: Area2D) -> void:
	$BlockSprites/Up.visible = false

func _on_droite_area_entered(area: Area2D) -> void:
	$BlockSprites/Right.visible = false

func _on_bas_area_entered(area: Area2D) -> void:
	$BlockSprites/Down.visible = false

func get_preview() -> Texture2D :
	return get_node_or_null("Sprite2D").texture
