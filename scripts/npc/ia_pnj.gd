extends CharacterBody2D
class_name Scientist

@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var animation: AnimationPlayer = $AnimationPlayer

@export var speed = 20000
# @export var evaluate_frequency = 30.0

@onready var moment_before : Enums.MOMENT
@onready var current_moment : Enums.MOMENT
@onready var current_activity : Enums.BUILDING_TYPE

@onready var showers_schedule = {
	Enums.MOMENT.MORNING_SHOWER: false,
	Enums.MOMENT.EVENING_SHOWER: false
}

func _ready() -> void:
	TimeManager.connect("time_changed", _on_time_changed)
	set_showers_schedule()

func _physics_process(delta):
	if !navigation_agent.is_target_reached():
		var new_point_direction = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = new_point_direction * speed * delta
		move_and_slide()
		handle_animation()
	else:
		handle_activity(delta)

func handle_animation():
	var dir = velocity.normalized()
	
	if dir.dot(Vector2.DOWN) > 0.5:
		animation.play("down_walk")
	elif dir.dot(Vector2.UP) > 0.5:
		animation.play("up_walk")
	elif dir.dot(Vector2.RIGHT) > 0.5:
		animation.play("right_walk")
	elif dir.dot(Vector2.LEFT) > 0.5:
		animation.play("left_walk")


func _on_time_changed(current_time):
	evaluate_goals(current_time)

func evaluate_goals(current_time):
	if current_moment != TimeManager.get_actual_moment():
		current_moment = TimeManager.get_actual_moment()
		set_goal()

func set_goal():
	match current_moment:
		Enums.MOMENT.MORNING_SHOWER:
			if showers_schedule[Enums.MOMENT.MORNING_SHOWER] :
				go_to_building(Enums.BUILDING_TYPE.SHOWER)
		Enums.MOMENT.BREAKFAST:
			go_to_building(Enums.BUILDING_TYPE.CANTEEN)
		Enums.MOMENT.MORNING_SHIFT:
			go_to_building(Enums.BUILDING_TYPE.LABO)
		Enums.MOMENT.PAUSE:
			go_to_building(Enums.BUILDING_TYPE.CANTEEN)
		Enums.MOMENT.AFTERNOON_SHIFT:
			go_to_building(Enums.BUILDING_TYPE.LABO)
		Enums.MOMENT.EVENING_SHOWER:
			if showers_schedule[Enums.MOMENT.EVENING_SHOWER] :
				go_to_building(Enums.BUILDING_TYPE.SHOWER)
		Enums.MOMENT.DINNER:
			go_to_building(Enums.BUILDING_TYPE.CANTEEN)
		Enums.MOMENT.SLEEP:
			go_to_building(Enums.BUILDING_TYPE.DORMITORY)
			
func handle_activity(delta):
	match current_activity:
		Enums.BUILDING_TYPE.CANTEEN:
			print("je mange")
		Enums.BUILDING_TYPE.DORMITORY:
			print("je dors")
		Enums.BUILDING_TYPE.SHOWER:
			print("je me douche")
		Enums.BUILDING_TYPE.LABO:
			print("je bosse")
		Enums.BUILDING_TYPE.TOILET:
			print("je chie")
			

func go_to_building(building_type : Enums.BUILDING_TYPE) -> void:
	current_activity = building_type
	navigation_agent.target_position = BuildingsInfo.get_closest_building(building_type, global_position)

func set_showers_schedule():
	var s = randi_range(1,3)
	match s:
		1:
			showers_schedule[Enums.MOMENT.MORNING_SHOWER] = true
		2:
			showers_schedule[Enums.MOMENT.EVENING_SHOWER] = true
		3:
			showers_schedule[Enums.MOMENT.MORNING_SHOWER] = true
			showers_schedule[Enums.MOMENT.EVENING_SHOWER] = true
