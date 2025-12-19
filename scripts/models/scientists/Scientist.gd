extends CharacterBody2D
class_name Scientist
## NPC scientist that navigates between buildings using pathfinding.
##
## Scientists move autonomously around the game world, traveling between buildings
## using Godot's NavigationAgent2D system. They have a probability-based behavior
## where they're more likely to change destinations the longer they stay in one place.
## Uses CharacterBody2D for physics-based movement with collision handling.

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Movement speed in pixels per second
@export var speed: int = 3000

## Number of in-game hours the scientist has spent at the current building
var hours_in_same_building: int = 0

## Whether the scientist is allowed to select a new destination
var can_change_target: bool = true

## Name of the currently playing walk animation
var current_animation: String = "up_walk"


func _ready() -> void:
	UiController.new_hour.connect(_on_new_hour)
	navigation_agent.target_position = Vector2(0, 0)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_number = rng.randi_range(0,2)
	setTextureSprite(random_number)


## Handles movement along the navigation path each frame.
## Updates velocity based on the next path position and plays appropriate animations.
## Changes target if the current destination becomes unreachable.
## [param delta] Time elapsed since the previous frame
func _physics_process(delta: float) -> void:
	if navigation_agent.is_target_reachable():
		var new_point_direction = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = new_point_direction * speed * delta
		move_and_slide()
		play_animation()
	else:
		change_target()


## Selects and plays the appropriate walk animation based on movement direction.
## Chooses between up, down, left, and right walk animations depending on
## the normalized velocity vector.
func play_animation() -> void:
	var normal_velocity := velocity.normalized()
	if normal_velocity.y < -0.9:
		current_animation = "up_walk"
	elif normal_velocity.y > 0.9:
		current_animation = "down_walk"
	elif normal_velocity.x < -0.9:
		current_animation = "left_walk"
	elif normal_velocity.x > 0.9:
		current_animation = "right_walk"
		
	animation_player.play(current_animation)


## Called each in-game hour to update behavior.
## Increments time counter and potentially triggers a destination change.
## [param hour] The current in-game hour (unused but required by signal)
func _on_new_hour(hour: int) -> void:
	hours_in_same_building += 1
	if want_to_change():
		change_target()


## Determines if the scientist wants to change buildings.
## Probability increases with time spent at current location (0-10% per hour).
## [return] True if the scientist wants to move to a new building, False otherwise
func want_to_change() -> bool:
	var chance = randi_range(0, 10)
	return (chance < hours_in_same_building) and can_change_target


## Called when the scientist reaches their destination.
## Hides the scientist and enables target changing.
func _on_navigation_agent_2d_navigation_finished() -> void:
	visible = false
	can_change_target = true


## Selects a new random building as the navigation target.
## Only changes target if the new position is significantly different (>10 pixels away).
## Resets the hours counter and makes the scientist visible.
func change_target() -> void:
	var new_position = get_random_building_position()
	if new_position.distance_to(navigation_agent.target_position) > 10:
		navigation_agent.target_position = new_position
		hours_in_same_building = 0
		visible = true
		can_change_target = false


## Gets a random building's door position from the game world.
## [return] Global position Vector2 of a randomly selected building's door
func get_random_building_position() -> Vector2:
	return GameController.get_random_building_position()
	

##Set Sprite Texture
##[param index] of the texture
func setTextureSprite(index: int) -> void:
	if index == 0:
		$Sprite2D.texture = load("res://assets/npc/scientifique2.png")
	if index==1:
		$Sprite2D.texture = load("res://assets/npc/scientifique.png")
	if index==2:
		$Sprite2D.texture = load("res://assets/npc/scientifique3.png")
