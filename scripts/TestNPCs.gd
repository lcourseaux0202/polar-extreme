extends Node2D

@onready var toilet: Building = $Buildings/Toilet
@onready var dormitory: Building = $Buildings/Dormitory
@onready var canteen: Building = $Buildings/Canteen
@onready var labo: Building = $Buildings/Labo
@onready var showers: Building = $Buildings/Showers

func _ready() -> void:
	toilet.set_building_type(Enums.BUILDING_TYPE.TOILET)
	dormitory.set_building_type(Enums.BUILDING_TYPE.DORMITORY)
	canteen.set_building_type(Enums.BUILDING_TYPE.CANTEEN)
	labo.set_building_type(Enums.BUILDING_TYPE.LABO)
	showers.set_building_type(Enums.BUILDING_TYPE.SHOWER)
	
	BuildingsInfo.add_building(toilet)
	BuildingsInfo.add_building(dormitory)
	BuildingsInfo.add_building(canteen)
	BuildingsInfo.add_building(labo)
	BuildingsInfo.add_building(showers)
