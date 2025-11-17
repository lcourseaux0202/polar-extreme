extends Building
class_name BuildingScience

# whether the building is producing science atm
@export var producing: bool

@export var science_per_second: float:		# per scientist
	set(value):
		value = clamp(value, 0, science_max_per_second)
		science_per_second = value

@export var science_max_per_second: int

# number of scientist producing science in the building
@export var nb_scientists_working: int:
	set(value):
		nb_scientists_working = clamp(value, 0, nb_scientists_slots)

# max number of scientists producing science
@export var nb_scientists_slots: int: 	
	set(value):
		nb_scientists_slots = value if (
			nb_scientists_slots + value > 1 
			&& nb_scientists_slots + value < nb_scientists_slots_max
		) else nb_scientists_slots

# capped number of the max number of scientists
@export var nb_scientists_slots_max: int

# Liste des projets du batiments
@export var projets_list: Array[Project] = []

func _init():
	#super._init()
	building_genre = Enums.BUILDING_GENRE.SCIENCE
	building_type = Enums.BUILDING_TYPE.NONE

func scientists_change_working(n: int):
	nb_scientists_working += n

func scientists_add_slots(n: int):
	nb_scientists_slots += n

func building_get_type() -> Enums.BUILDING_TYPE:
	return building_type
	
func science_change_per_second(value: float) -> void:
	science_per_second = value
	GameController.get_gauges().change_science_per_second(value)

func science_production_pause() -> void:
	producing = false
