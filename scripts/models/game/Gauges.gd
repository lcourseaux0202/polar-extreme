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

var pollution := 0.0:
	set(value):
		if value <= 0 :
			pollution = 0
		else:
			pollution = value
		UiController.emit_pollution_changed(pollution)
var pollution_per_seconds := 0.0

var wellness := 100.0:
	set (value):
		wellness = clamp(value, wellness_min, wellness_max)
		UiController.emit_wellness_changed(wellness)
var wellness_max := 200.0
var wellness_min := 001.0
var wellness_decrement_factor := -0.9

### GAUGES MANAGEMENT ##

# Science
func get_science() -> float:
	return science

func change_science(value: float) -> bool:
	if science + value >= 0:
		science += value
		return true
	else:
		return false

func get_science_per_second() -> float:
	return science_per_seconds

func change_science_per_second(value: float) -> void:
	science_per_seconds += value


## Pollution
func get_pollution() -> float:
	return pollution
	
func get_pollution_per_second() -> float:
	return pollution_per_seconds

func change_pollution(value: float) -> bool:
	var changed = false
	if pollution > 0:
		changed = true
	if value > 0:
		# more wellness = less pollution gain (and the reverse)
		pollution += value * (100 / wellness)
	else:
		# more wellness = more pollution loss
		pollution += value * (wellness / 100)
		
	if pollution <= 0:
		change_wellness(0.1)
		if changed:
			print("Gauges, pollution : pollution < 0, gain 0.1% wellness per update") 

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
func update_gauges():
	change_science(science_per_seconds * GameController.update_time)
	change_pollution(pollution_per_seconds * GameController.update_time)
	change_wellness(wellness_decrement_factor * GameController.update_time)
