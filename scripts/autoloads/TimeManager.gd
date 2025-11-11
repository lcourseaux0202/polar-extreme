extends Node

var current_time := 350.0
var time_speed := 20
var day_length := 1440

var daily_schedule = {
	6: Enums.MOMENT.MORNING_SHOWER,
	7: Enums.MOMENT.BREAKFAST,
	8: Enums.MOMENT.MORNING_SHIFT,
	12: Enums.MOMENT.PAUSE,
	13: Enums.MOMENT.AFTERNOON_SHIFT,
	18: Enums.MOMENT.EVENING_SHOWER,
	19: Enums.MOMENT.DINNER,
	20: Enums.MOMENT.SLEEP
}

signal new_day()
signal time_changed(current_time)

func _process(delta: float) -> void:
	current_time += delta * time_speed
	if current_time >= day_length:
		current_time = 0
		emit_signal("new_day")
	emit_signal("time_changed", current_time)

func get_actual_moment() -> Enums.MOMENT:
	var current_hour = get_time_hours()
	var last_activity = null
	var last_time = -1

	for hour in daily_schedule.keys():
		if hour <= current_hour and hour > last_time:
			last_time = hour
			last_activity = daily_schedule[hour]
	
	if last_activity == null:
		last_activity = Enums.MOMENT.SLEEP
		
	return last_activity

func get_time_hours():
	return int(current_time / 60)

func get_time_minutes():
	return int(current_time) % 60

func get_formatted_time() -> String:
	var h = get_time_hours()
	var m = get_time_minutes()
	return "%02d:%02d" % [h, m]
