class_name Project
extends Node

var project_name: String
var project_description: String
var project_state: int:
	set (value):
		project_state = max(value, 0)	# 0: created, 1: running, 2: paused, 3: ended, 4: seen
var timer: Timer

var building_id := -1	# associated building
var project_id := -1

var requirement_scientists: int 	# number of scientifics required
var project_time: int:
	set(value):
		project_time = max(value, 0)
var failure_chances: int:		# chance of success, integer between 0 and 100
	set(value):
		failure_chances = clamp(value, 0, 100)

var reward_science
var reward_production
var reward_slots

func _init(rew_sci: int, rew_prod: int, rew_sl: int, bid: int, pid: int) -> void:
	reward_science = rew_sci
	reward_production = rew_prod
	reward_slots = rew_sl
	building_id = bid
	project_id = pid
	project_state = 0
	
func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(finish)
	
func console(string: String) -> void:
	print(BuildingIdManager.get_building(building_id).get_building_name() + ": " + string + " project " + project_name)

func start():
	timer.paused = false
	project_state = 1
	console("starting/resuming")
	
func pause():
	timer.paused = true
	project_state = 2
	console("pausing")
	
func finish():
	project_state = 3
	console("finishing")
	
func validate():
	project_state = 4
	console("validate")
	
func time_left() -> int:
	return int(timer.time_left)
