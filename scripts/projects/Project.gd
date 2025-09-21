class_name Project
extends Node

@export var project_name: String
@export var project_description: String

enum project_type { UPGRADE, RESEARCH }
enum reward_type { 
	SCIENCE, 		# fixed amount of science
	PRODUCTION,		# science/seconds cap is upped
	EFFICIENCY		# scientists capped is upped
	}

var type: project_type		# building upgrade or research
var requirement: int 		# number of scientifics required
var success_rate: int		# chance of success, integer between 0 and 100

var reward

func __init(new_type: project_type, number: int):
	self.type = new_type
	self.requirement = number

func get_reward():
	match type:
		project_type.RESEARCH:
			return
		project_type.UPGRADE:
			return

func get_reward_research():
	print("Grant research reward " + reward)
