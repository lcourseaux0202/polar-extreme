extends Node

@export var label_text : String

func _on_mouse_entered() -> void:
	var test = Label.new()
	test.text = label_text
	test.visible = true
	test.global_position = Vector2(10, -50)
	add_child(test)
