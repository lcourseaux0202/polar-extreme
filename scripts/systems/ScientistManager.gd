extends Node
class_name ScientistManager

var scientist_factory : ScientistFactory = load("res://scripts/factories/ScientistFactory.gd").new()

var scientist_total = 0
var scientist_occupied = 0

const SCIENTIST_START_PRICE : float = 1
const SCIENTIST_PRICE_FACTOR : float = 1.4
var scientist_price = SCIENTIST_START_PRICE

func enroll_scientist() -> Scientist :
	scientist_total += 1
	return scientist_factory.make_scientist()
	
func assign_scientist() :
	scientist_occupied += 1
	
func deassign_scientist() :
	scientist_occupied -= 1

func enough_scientist_for_assignement(n_scientist : int) -> bool :
	return n_scientist <= (scientist_total - scientist_occupied) 
	
func get_scientist_total() -> int :
	return scientist_total
	
func get_scientist_occupied() -> int :
	return scientist_occupied

func get_scientist_price() -> float:
	return scientist_price
	
func increase_price()->void:
	scientist_price = scientist_price * SCIENTIST_PRICE_FACTOR
