extends TileMapLayer
class_name WorldGrid

@onready var scientist_spawn_position: Marker2D = $ScientistSpawnPosition
@onready var scientist_container = $ScientistContainer
@onready var building_container = $BuildingContainer
@onready var plane: ScientistPlane = $Plane

var scientists_to_place : Array[Scientist]
var plane_spawn = 4000

func _ready() -> void:
	plane.make_scientist.connect(_on_make_scientist)
	plane.anim_end.connect(_restart_animation)

func get_scientist_spawn_position() -> Vector2:
	return scientist_spawn_position.global_position

func add_scientist(scientist_scene : Scientist) :
	scientists_to_place.append(scientist_scene)
	if not plane.anim :
		plane.start_animation(Vector2(plane_spawn,scientist_spawn_position.global_position.y), scientist_spawn_position.global_position)
	
	
func _on_make_scientist():
	for scientist in scientists_to_place:
		scientist.global_position = scientist_spawn_position.global_position
		scientist.global_position.x += randf_range(-30,30)
		scientist_container.add_child(scientist)
		
	scientists_to_place.clear()

func add_building(building_scene : Building):
	building_container.add_child(building_scene)
	building_scene.emit_particles()

	
func _restart_animation():
	if not scientists_to_place.is_empty() and not plane.anim:
		plane.start_animation(Vector2(plane_spawn,scientist_spawn_position.global_position.y), scientist_spawn_position.global_position)
