extends Node

signal build_batiment(bname : Enums.BUILDING_NAME)

signal start_building(building:Building)
signal start_placing_path()

signal validate_building_placement(building:Building)
signal validate_placing_path(path:Path)

func emit_build_batiment(bname : Enums.BUILDING_NAME):
	build_batiment.emit(bname)


func emit_start_building(building:Building):
	start_building.emit(building)
	
func emit_validate_building_placement(building:Building):
	validate_building_placement.emit(building)
	
	
func emit_start_building_path():
	start_placing_path.emit()

func emit_validate_building_path(path:Path):
	validate_placing_path.emit(path)

	
