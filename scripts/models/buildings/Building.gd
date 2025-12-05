extends  Area2D
class_name Building

# infos
@export var id: int
@export var building_name: String
@export var building_description: String
@export var building_genre : Enums.BUILDING_GENRE
@export var building_type: Enums.BUILDING_TYPE
@export var pollution_per_second: float

@onready var mouse_hover := false

signal building_clicked(building : Building)

func get_id() -> int:
	return id
	
func set_id(new_id: int) -> void:
	id = new_id

func get_building_name() -> String:
	return building_name
	
func get_building_type() -> Enums.BUILDING_TYPE:
	return building_type

func get_pollution() -> float:
	return pollution_per_second
	
func change_pollution(value: float) -> void:
	pollution_per_second += value
	GameController.get_gauges().change_pollution_per_second(value)

func delete():
	queue_free()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and mouse_hover:
		GameController.zoom_camera(self)

func _on_mouse_entered() -> void:
	mouse_hover = true
	

func _on_mouse_exited() -> void:
	mouse_hover = false
