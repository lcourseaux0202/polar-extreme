extends  Area2D
class_name Building

# infos
@export var id: int
@export var building_name: String
@export var building_description: String
@export var building_genre: Enums.BUILDING_GENRE
@export var building_type: Enums.BUILDING_TYPE
@export var pollution_per_second: float
@export var max_scientist_number : int
@export var price : int

var scientist_number : int = 0
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var building_zone: CollisionShape2D = $BuildingZone

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
		#GameController.zoom_camera(self)
		UiController.emit_click_on_building(self)

func _on_mouse_entered() -> void:
	mouse_hover = true
	UiController.display_building_basic_info.emit(self)
	

func _on_mouse_exited() -> void:
	mouse_hover = false
	UiController.display_building_basic_info.emit(null)
	
func get_door_position():
	var door : Marker2D = get_node_or_null("Door")
	return door.global_position
	
func emit_particles():
	particles.scale = building_zone.shape.get_rect().size / 100
	particles.amount = building_zone.shape.get_rect().size.length() / 2
	if not particles.emitting:
		particles.emitting = true
		
func _on_gpu_particles_2d_finished() -> void:
	particles.queue_free()

#func add_scientist() -> bool:
	#if scientist_number < max_scientist_number:
		#scientist_number += 1
		#return true
	#else :
		#return false
	#
#func remove_scientist() -> bool:
	#if scientist_number > 0:
		#scientist_number -= 1
		#return true
	#else:
		#return false
	#
#func get_scientist_number() -> int:
	#return scientist_number
#
#func get_max_scientist_number() -> int:
	#return max_scientist_number
