extends Node

const PATH_SCENE = "res://v2/scenes/buildings/Path.tscn"

func create_path():
	var scene = load(PATH_SCENE).instantiate()
	return scene
