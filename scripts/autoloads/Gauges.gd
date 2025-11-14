class_name Gauges
extends Node

static var science := 0.0
static var science_per_seconds := 0.0

static var pollution := 1000.0
static var pollution_per_seconds := 0.0

static var update_time := 2.0


## Science
static func get_science() -> float:
	return science

static func change_science(value: float) -> bool:
	if science + value > 0:
		science += value
		print("Gauges, science : enough credit, deduce and validate request")
		return true
	else:
		print("Gauges, science : NOT enough credit, do no deduce and deny request")
		return false

static func get_science_per_second() -> float:
	return science

static func change_science_per_second(value: float) -> void:
		science_per_seconds += value


# pollution
static func get_pollution() -> float:
	return pollution
	
static func get_pollution_per_second() -> float:
	return pollution_per_seconds

static func change_pollution(value: float) -> bool:
	pollution += value
	if pollution <= 0:
		# todo : reward
		print("Gauges, pollution : pollution < 0 TODO") 
	return true

static func change_pollution_per_second(value: float) -> void:
	pollution_per_seconds += value


## Update (every 2 seconds)
func _ready():
	var timer = Timer.new()
	timer.wait_time = update_time
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_update_gauges)

func _update_gauges():
	change_science(science_per_seconds * update_time)
	change_pollution(pollution_per_seconds * update_time)
