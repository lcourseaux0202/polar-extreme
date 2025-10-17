class_name Building
extends Area2D

enum BUILDING_TYPE { SCIENCE, UTILITY }

# infos
@export var id: int
@export var building_name: String
@export var building_description: String

@export var projets_list: Array[Project] = []

func _init():
	id = BuildingIdManager.register(self)

func destroy():
	BuildingIdManager.remove(id)

func get_id():
	return id

func get_building_name():
	return building_name

func project_add(project: Project):
	projets_list.append(project)
