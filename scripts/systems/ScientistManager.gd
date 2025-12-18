extends Node
class_name ScientistManager
## Manages the scientist workforce and their associated costs.
##
## This singleton-style manager tracks total scientists, their assignment status,
## and handles pricing with exponential growth. Uses a factory pattern to instantiate
## new scientists. The pricing system starts at a base cost and increases exponentially
## with each hire, with diminishing growth rates at higher prices.

## Factory instance for creating new Scientist nodes
var scientist_factory: ScientistFactory = load("res://scripts/factories/ScientistFactory.gd").new()

## Total number of scientists enrolled (both working and idle)
var scientist_total: int = 0

## Number of scientists currently assigned to buildings
var scientist_occupied: int = 0:
	set(value):
		scientist_occupied = value
		UiController.update_assign_scientist.emit()

## Base starting price for hiring the first scientist
const SCIENTIST_START_PRICE: float = 1.0

## Multiplier applied to price after each hire (exponential growth)
@export var scientist_price_factor: float = 1.2

## Current cost to hire the next scientist
var scientist_price: float = SCIENTIST_START_PRICE

## Pollution generated when a scientist travels between buildings
@export var scientist_pollution_travel: int = 50

## Pollution generated per second per scientist (minimum value: 2)
@export var scientist_pollution_per_second: int = 5:
	set(value):
		if value < 2:
			scientist_pollution_per_second = 2
		else:
			scientist_pollution_per_second = value


## Creates and enrolls a new scientist.
## Increments the total scientist count and returns the instantiated scientist.
## [return] Newly created Scientist instance
func enroll_scientist() -> Scientist:
	scientist_total += 1
	return scientist_factory.make_scientist()


## Marks a scientist as assigned to a building.
## Increments the occupied scientist counter.
func assign_scientist() -> void:
	scientist_occupied += 1


## Marks a scientist as unassigned from a building.
## Decrements the occupied scientist counter.
func deassign_scientist() -> void:
	scientist_occupied -= 1
	
func change_scientists_assigned(n: int) :
	scientist_occupied += n


## Checks if there are enough idle scientists available for assignment.
## [param n_scientist] Number of scientists needed
## [return] True if enough unoccupied scientists exist, False otherwise
func enough_scientist_for_assignement(n_scientist: int) -> bool:
	return n_scientist <= (scientist_total - scientist_occupied)


## Gets the total number of enrolled scientists.
## [return] Total scientist count (occupied + unoccupied)
func get_scientist_total() -> int:
	return scientist_total


## Gets the number of scientists currently assigned to buildings.
## [return] Number of occupied scientists
func get_scientist_occupied() -> int:
	return scientist_occupied


## Gets the number of idle scientists available for assignment.
## [return] Number of unoccupied scientists
func get_scientist_non_occupied() -> int:
	return scientist_total - scientist_occupied


## Gets the current hiring cost for the next scientist.
## [return] Price in currency units
func get_scientist_price() -> float:
	return scientist_price


## Gets the pollution generated when scientists travel.
## [return] Pollution points per travel action
func get_scientist_pollution_travel() -> int:
	return scientist_pollution_travel


## Gets the pollution generated per second per scientist.
## [return] Pollution points per second per scientist
func get_scientist_pollution_per_second() -> int:
	return scientist_pollution_per_second


## Changes the pollution rate per second for all scientists.
## [param x] Amount to add to the pollution rate (can be negative, minimum 2)
func change_scientist_pollution_per_second(x: int) -> void:
	scientist_pollution_per_second += x


## Changes the pollution generated when scientists travel.
## [param x] Amount to add to travel pollution (can be negative)
func change_scientist_pollution_travel(x: int) -> void:
	scientist_pollution_travel += x


## Increases the hiring price using exponential growth.
## Growth factor decreases at high prices:
## - 1.2x up to 1000
## - 1.1x from 1000 to 10000
## - 1.0x (flat) above 10000
func increase_price() -> void:
	scientist_price = scientist_price * scientist_price_factor
	if scientist_price > 10000:
		scientist_price_factor = 1.0
	elif scientist_price > 1000:
		scientist_price_factor = 1.1
