extends CharacterBody2D
class_name Sqcientist

@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var animation: AnimationPlayer = $AnimationPlayer

@export var speed = 20000 # vitesse de déplacement

@onready var current_moment : Enums.MOMENT # moment de la journée, va être déterminé par TimeManager
@onready var current_activity : Enums.BUILDING_TYPE # type de bâtiment ciblé pour s'y déplacer et déterminer le comportement du scientifique

@onready var showers_schedule = {
	Enums.MOMENT.MORNING_SHOWER: false, # si vrai : le pnj prend sa douche le matin
	Enums.MOMENT.EVENING_SHOWER: false  # si vrai : le pnj prend sa douche le soir
}



func _ready() -> void:
	#TimeManager.connect("time_changed", _on_time_changed)
	set_showers_schedule()

func set_showers_schedule():
	var s = randi_range(1,3)
	match s:
		1: showers_schedule[Enums.MOMENT.MORNING_SHOWER] = true
		2: showers_schedule[Enums.MOMENT.EVENING_SHOWER] = true
		3: 
			showers_schedule[Enums.MOMENT.MORNING_SHOWER] = true
			showers_schedule[Enums.MOMENT.EVENING_SHOWER] = true



func _physics_process(delta):
	if !navigation_agent.is_target_reached(): # tant que le pnj n'a pas atteint le batiment ciblé
		var new_point_direction = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = new_point_direction * speed * delta
		move_and_slide()
		move_animation()
	else:
		handle_activity(delta)

func move_animation():
	var dir = velocity.normalized()
	
	if dir.dot(Vector2.DOWN) > 0.5:
		animation.play("down_walk")
	elif dir.dot(Vector2.UP) > 0.5:
		animation.play("up_walk")
	elif dir.dot(Vector2.RIGHT) > 0.5:
		animation.play("right_walk")
	elif dir.dot(Vector2.LEFT) > 0.5:
		animation.play("left_walk")

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



# dès qu'on reçoit le signal 'time_changed' (envoyé par TimeManager)
func _on_time_changed(current_time):
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

func go_to_building(building_type : Enums.BUILDING_TYPE) -> void:
	current_activity = building_type
	navigation_agent.target_position = GlobalBuildingManager.get_closest_building(current_activity, global_position)
