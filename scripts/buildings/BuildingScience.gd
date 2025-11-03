class_name BuildingScience
extends Building


@export var producing: bool 	# whether the building is producing science atm

@export var science_per_second: float:		# per scientist
	set(value):
		science_per_second = clamp(value, 0, max_science_per_second)
		
@export var max_science_per_second: int

# number of scientist producing science in the building
@export var nb_scientists: int:
	set(value):
		nb_scientists = clamp(value, 0, nb_scientists_max)

# max number of scientists producing science
@export var nb_scientists_max: int: 	
	set(value):
		nb_scientists_max = value if (nb_scientists_max + value > 1) else 1

# capped number of the max number of scientists
@export var nb_scientists_max_max: int

# Liste des projets du batiments
@export var projets = []

func _init():
	super._init()
	building_type = BUILDING_TYPE.SCIENCE

func change_max_scientists(n: int):
	nb_scientists_max += n
