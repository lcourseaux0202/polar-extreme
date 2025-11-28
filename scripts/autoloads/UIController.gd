extends Node

signal build_batiment(bname : Enums.BUILDING_TYPE)

signal start_building(building:Building)
signal start_placing_path()
signal start_delete_object()

signal validate_building_placement(building:Building)
signal validate_placing_path(path:Path)
signal delete_building

signal enroll_scientist()
signal new_hour(hour)

signal zoom_building(building_position : Vector2)

signal science_changed(science: float)
signal science_second_changed(science_per_second: float)
signal pollution_changed(pollution: float)
signal wellness_changed(wellness: float)

func emit_build_batiment(bname : Enums.BUILDING_TYPE):
	build_batiment.emit(bname)

func emit_start_building(building:Building):
	start_building.emit(building)
	
func emit_validate_building_placement(building:Building):
	validate_building_placement.emit(building)
	
func emit_delete_building(building:Building):
	delete_building.emit(building)
	
func emit_start_building_path():
	start_placing_path.emit()

func emit_validate_building_path(path:Path):
	validate_placing_path.emit(path)

func emit_enroll_scientist():
	enroll_scientist.emit()

func emit_start_delete_object():
	start_delete_object.emit()
	
func emit_new_hour(hour):
	new_hour.emit(hour)

func emit_zoom_building(building_position : Vector2):
	zoom_building.emit(building_position)

func emit_science_changed(science: float) -> void:
	science_changed.emit(science)

func emit_science_second_changed(science_per_second: float) -> void:
	science_second_changed.emit(science_per_second)

func emit_pollution_changed(pollution: float) -> void:
	pollution_changed.emit(pollution)

func emit_wellness_changed(wellness: float) -> void:
	wellness_changed.emit(wellness)
