extends Area2D
class_name Building
## Base class for all buildings in the game.
##
## This class provides core building functionality including identification, pollution tracking,
## mouse interaction, and visual effects. Buildings use Area2D for collision detection and
## emit signals when clicked. All specific building types (science, production, etc.) inherit
## from this base class.

# infos
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var building_zone: CollisionShape2D = $BuildingZone

@export var scientist_places:int
## Unique identifier for this building instance
@export var id: int

## Display name of the building
@export var building_name: String

## Description text for UI display
@export var building_description: String

## General category of the building (from Enums.BUILDING_GENRE)
@export var building_genre: Enums.BUILDING_GENRE

## Specific type of the building (from Enums.BUILDING_TYPE)
@export var building_type: Enums.BUILDING_TYPE

## Pollution generated per second by this building
@export var pollution_per_second: float = 0:
	set(value):
		GameController.gauges.change_pollution_per_second(value - pollution_per_second)
		pollution_per_second = value

## Cost to construct this building
@export var price: int

## Tracks whether the mouse cursor is currently over this building
var mouse_hover: bool = false


## Gets the unique identifier of this building.
## [return] The building's ID number
func get_id() -> int:
	return id


## Sets a new unique identifier for this building.
## [param new_id] The new ID to assign to this building
func set_id(new_id: int) -> void:
	id = new_id


## Gets the display name of this building.
## [return] The building's name as a string
func get_building_name() -> String:
	return building_name


## Gets the specific type of this building.
## [return] The building type from Enums.BUILDING_TYPE
func get_building_type() -> Enums.BUILDING_TYPE:
	return building_type


## Gets the current pollution production rate.
## [return] Pollution points generated per second
func get_pollution() -> float:
	return pollution_per_second


## Changes the pollution production rate of this building.
## Updates the global pollution counter accordingly.
## [param value] Amount to add to pollution_per_second (can be negative)
func change_pollution(value: float) -> void:
	pollution_per_second += value


## Marks this building for deletion and removes it from the scene tree.
func delete() -> void:
	queue_free()


## Handles mouse click input on the building.
## Emits a signal to notify UI when the building is clicked.
## [param event] The input event to process
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and mouse_hover:
		UiController.emit_click_on_building(self)


## Called when the mouse cursor enters the building's collision area.
## Changes cursor appearance and displays building info in UI.
func _on_mouse_entered() -> void:
	mouse_hover = true
	var cursor_texture = load("res://assets/cursor/ice_link.png")
	Input.set_custom_mouse_cursor(cursor_texture)
	UiController.display_building_basic_info.emit(self)


## Called when the mouse cursor exits the building's collision area.
## Restores default cursor and clears building info from UI.
func _on_mouse_exited() -> void:
	mouse_hover = false
	var cursor_texture = load("res://assets/cursor/Ice-normal.png")
	Input.set_custom_mouse_cursor(cursor_texture)
	UiController.display_building_basic_info.emit(null)


## Gets the global position of the building's door marker.
## [return] Global position Vector2 of the door, or null if no door exists
func get_door_position() -> Vector2:
	var door: Marker2D = get_node_or_null("Door")
	if door:
		return door.global_position
	return Vector2.ZERO


## Triggers particle emission effect scaled to the building's size.
## Configures particle scale and amount based on building zone dimensions.
func emit_particles() -> void:
	particles.scale = building_zone.shape.get_rect().size / 100
	particles.amount = building_zone.shape.get_rect().size.length() / 2
	if not particles.emitting:
		particles.emitting = true


## Called when particle emission completes.
## Removes the particle system from the scene tree.
func _on_gpu_particles_2d_finished() -> void:
	particles.queue_free()
