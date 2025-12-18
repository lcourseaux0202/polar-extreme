extends Building
class_name BuildingScience
## Science-producing building that employs scientists to generate research points.
##
## This class manages scientists working in a laboratory or research facility.
## Scientists generate science points per second, which are tracked by the GameController.
## The building maintains an array of available research projects and tracks current
## workforce capacity vs maximum slots.

@onready var door: Marker2D = $Door

## Science points generated per second per scientist
@export var science_per_second: float:		# per scientist
	set(value):
		GameController.gauges.change_science_per_second((value - science_per_second) * nb_scientists_working)
		science_per_second = value

## Number of scientists currently working in this building
var nb_scientists_working = 0:
	set(value):
		GameController.gauges.change_science_per_second((value - nb_scientists_working) * science_per_second)
		nb_scientists_working = value

## Max number of scientifics working in the building
@export var nb_scientists_slots: int

## Array of research projects available in this building
var projects_list: Array[Project] = []


func _init() -> void:
	building_genre = Enums.BUILDING_GENRE.SCIENCE
	building_type = Enums.BUILDING_TYPE.NONE


## Sets the list of available research projects for this building.
## [param plist] Array of Project objects to assign to this building
func set_projects(plist: Array[Project]) -> void:
	projects_list = plist
	

## Sets the maximum number of scientist slots available.
## Only updates if the new value would result in more than 1 slot.
## [param value] The new maximum number of scientist slots
func set_nbr_scientist_slots(value: int) -> void:
	if nb_scientists_slots + value > 1:
		nb_scientists_slots = value
	else :
		nb_scientists_slots = 1

## Adds a scientist to the building if space is available.
## Updates the global science production rate accordingly.
## [return] True if scientist was successfully added, False if building is at capacity
func add_scientist() -> bool:
	if nb_scientists_working < nb_scientists_slots:
		nb_scientists_working += 1
		return true
	else :
		return false


## Removes a scientist from the building if any are present.
## Updates the global science production rate accordingly.
## [return] True if scientist was successfully removed, False if building has no scientists
func remove_scientist() -> bool:
	if nb_scientists_working > 0:
		nb_scientists_working -= 1
		return true
	else:
		return false


## Increases the maximum number of scientist slots in the building.
## [param n] Number of additional slots to add
func scientists_add_slots(n: int) -> void:
	nb_scientists_slots += n


## Gets the specific building type.
## [return] The building type from the Enums.BUILDING_TYPE enumeration
func building_get_type() -> Enums.BUILDING_TYPE:
	return building_type


## Changes the science production rate per scientist.
## Updates global science production based on current workforce.
## [param value] Amount to add to science_per_second (can be negative)
func change_science_per_second_production(value: float) -> void:
	science_per_second += value


## Gets the list of available research projects.
## [return] Array of Project objects available in this building
func get_project_list() -> Array[Project]:
	return projects_list


## Gets the current number of working scientists.
## [return] Number of scientists currently employed in the building
func get_nbr_scientist() -> int:
	return nb_scientists_working


## Gets the maximum capacity of scientists.
## [return] Maximum number of scientist slots available
func get_nbr_scientist_max() -> int:
	return nb_scientists_slots


## Calculates current total science production.
## [return] Total science points generated per second (scientists × production rate)
func get_science_production() -> float:
	return nb_scientists_working * science_per_second


## Calculates the ratio of current to maximum science production.
## [return] Ratio between 0.0 (no scientists) and 1.0 (full capacity)
func get_science_production_ratio() -> float:
	if nb_scientists_slots == 0:
		return 0.0
	return float(nb_scientists_working) / float(nb_scientists_slots)
	
func get_infos() -> String:
	var text = ""
	if science_per_second > 0:
		text += "Science produite chaque seconde : " + str(int(science_per_second)) + "\n"
	if scientist_places > 0:
		text += "Capacité de scientifiques : +" + str(int(scientist_places)) + "\n"
	if pollution_per_second > 0:
		text += "Pollution par seconde :" + str(int(pollution_per_second)) + "\n"
	if wellness_value > 0:
		text += "Augmentation du bien être : " + str(int(wellness_value))
	return text
