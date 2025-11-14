extends Node
class_name WorldManager

var world_grid : TileMapLayer

func place_building(building : Building):
	world_grid.add_child(building)
	
func place_path(path : Path):
	world_grid.add_child(path)
	
