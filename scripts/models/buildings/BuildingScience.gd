extends Building
class_name BuildingScience

@export var producing: bool 	# whether the building is producing science atm
@onready var door: Marker2D = $Door
# whether the building is producing science atm

@export var science_per_second: float = 0		# per scientist

@export var science_max_per_second: int

# number of scientist producing science in the building
var nb_scientists_working = 0

# max number of scientists producing science
@export var nb_scientists_slots: int


# capped number of the max number of scientists
@export var nb_scientists_slots_max: int

# Liste des projets du batiments
var projects_list: Array[Project] = []

func _init():
	#super._init()
	building_genre = Enums.BUILDING_GENRE.SCIENCE
	building_type = Enums.BUILDING_TYPE.NONE

func set_projects(plist: Array[Project]) -> void:
	projects_list = plist
	
func set_science_per_second(value : float) -> void:
	value = clamp(value, 0, science_max_per_second)
	science_per_second = value
	
func set_nbr_scientist_slots(value : int) -> void:
	if nb_scientists_slots + value > 1 && nb_scientists_slots + value < nb_scientists_slots_max :
		nb_scientists_slots = value 
	else :
		nb_scientists_slots

func set_nbr_scientist_slots_max(value : int) -> void:
	nb_scientists_slots_max = value

#func scientists_change_working(n: int):
	#nb_scientists_working += n
	
func add_scientist() -> bool:
	if nb_scientists_working < nb_scientists_slots:
		nb_scientists_working += 1
		return true
	else :
		return false

func remove_scientist() -> bool:
	if nb_scientists_working > 0:
		nb_scientists_working -= 1
		return true
	else:
		return false
	
func scientists_add_slots(n: int):
	nb_scientists_slots += n

func building_get_type() -> Enums.BUILDING_TYPE:
	return building_type
	
func science_change_per_second(value: float) -> void:
	science_per_second = value
	GameController.get_gauges().change_science_per_second(value)

func science_production_pause() -> void:
	producing = false
	GameController.get_gauges().change_science_per_second(-1 * science_per_second)

func production_pause() -> void:
	producing = false

func get_project_list() -> Array[Project]:
	return projects_list

func get_nbr_scientist() -> int:
	return nb_scientists_working
	
func get_nbr_scientist_max() -> int:
	return nb_scientists_slots
