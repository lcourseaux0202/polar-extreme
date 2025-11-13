extends Node

signal build_batiment(bname : Enums.BUILDING_NAME)
signal build_path
signal validate_building_placement()

func emit_build_batiment(bname : Enums.BUILDING_NAME):
	build_batiment.emit(bname)

func emit_build_path():
	build_path.emit()

func emit_validate_building_placement():
	validate_building_placement.emit()
