class_name Project
extends Node

var project_name: String
var project_id := -1
var project_description: String		# TODO
var project_state: int:
	set (value):
		project_state = max(value, 0)	# 0: created, 1: running, 2: paused, 3: ended, 4: seen

var building_id := -1	# associated building

var requirement_scientists: int 	# number of scientifics required for the project
var timer: Timer
var project_time: int:
	set(value):
		project_time = max(value, 0)

var failure_chances: int:			# chance of success, integer between 0 and 100, MOST PROBABLY WONT BE IMPLEMENTED
	set(value):
		failure_chances = clamp(value, 0, 100)

var reward_science 					# one time flat amount of science 
var reward_production				# per second science increase
var reward_slots					# number of scientist allowed to work at the same time
var reward_pollution				# one time flat amount of pollution
var reward_pollution_per_second		# per second pollution increase

func _init(pid: int, pname: String, rew_sci: int, rew_prod: int, rew_sl: int, rew_poll: int, rew_poll_ps) -> void:
	project_id = pid
	project_name = pname
	reward_science = rew_sci
	reward_production = rew_prod
	reward_slots = rew_sl
	reward_pollution = rew_poll
	reward_pollution_per_second = rew_poll_ps
	project_state = 0
	
func set_building_id(id: int) -> void:
	building_id = id

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(finish)
	
func console(string: String) -> void:
	print(BuildingManager.get_building(building_id).get_building_name() + ": " + string + " project " + project_name)

func start():
	timer.paused = false
	if project_state == 0:
		console("starting")
		project_state = 1
	elif project_state == 1:
		console("already running")
	elif project_state == 2:
		console("resuming")
		project_state = 1
	elif project_state >= 3:
		console("already finished")
	
func pause():
	timer.paused = true
	if project_state == 1:
		project_state = 2
		console("pausing")
	else:
		console("not running")
	
func finish():
	project_state = 3
	console("finishing")
	
func validate():
	project_state = 4
	console("validate")
	
func time_left() -> int:
	return int(timer.time_left)
