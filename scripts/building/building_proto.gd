extends Marker2D

class_name Building

var building_type : Enums.BUILDING_TYPE

func set_building_type(type : Enums.BUILDING_TYPE):
	building_type = type

func get_building_type() -> Enums.BUILDING_TYPE:
	return building_type
