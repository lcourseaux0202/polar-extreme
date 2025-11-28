extends Button

@export var btype : Enums.BUILDING_TYPE
 
func _pressed() -> void:
	UiController.emit_build_batiment(btype)
	
