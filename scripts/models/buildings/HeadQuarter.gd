extends Area2D
class_name HeadQuarter

@onready var path_detector: NavigationAgent2D = $PathDetector

func check_if_building_reachable(building_position : Vector2) -> bool:
	path_detector.target_position = building_position
	return path_detector.is_target_reachable()
