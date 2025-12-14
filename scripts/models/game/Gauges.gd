class_name Gauges
extends Node

var science := 0.0:
	set(value):
		science = value
		UiController.emit_science_changed(science)
		
var science_per_seconds := 0.0:
	set(value):
		science_per_seconds = value
		UiController.emit_science_second_changed(science_per_seconds)

var pollution := 1000.0:
	set(value):
		pollution = value
		UiController.emit_pollution_changed(pollution)
var pollution_per_seconds := 0.0

var wellness := 100.0:
	set (value):
		wellness = clamp(value, wellness_min, wellness_max)
		UiController.emit_wellness_changed(wellness)
var wellness_max := 2.00
var wellness_min := 0.01
var wellness_decrement_factor := 0.005

var update_time := 2.0

## GAUGES MANAGEMENT


## Science
func get_science() -> float:
	return science

func change_science(value: float) -> bool:
	if science + value > 0:
		science += value
		print("Gauges, science : enough credit, deduce and validate request")
		return true
	else:
		print("Gauges, science : NOT enough credit, do no deduce and deny request")
		return false

func get_science_per_second() -> float:
	return science

func change_science_per_second(value: float) -> void:
	science_per_seconds += value


# Pollution
func get_pollution() -> float:
	return pollution
	
func get_pollution_per_second() -> float:
	return pollution_per_seconds

func change_pollution(value: float) -> bool:
	pollution += value * (100 / wellness)
	if pollution <= 0:
		print("Gauges, pollution : pollution < 0, gain 1% wellness") 
		change_wellness(0.01)
	return true

func change_pollution_per_second(value: float) -> void:
	pollution_per_seconds += value


# Wellness
func get_wellness() -> float:
	return wellness

func change_wellness(w: float) -> void:
	var new_wellness = wellness + w
	wellness = new_wellness if (new_wellness > wellness_min) else wellness_min


## UPDATE (every 2 seconds)
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
	change_wellness(wellness_decrement_factor * update_time)
