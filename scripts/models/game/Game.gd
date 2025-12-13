extends Node2D

@onready var world_grid: WorldGrid = %WorldGrid
@onready var path: Path = $PathRegions/Path


func _ready():
	GameController.set_grid(%WorldGrid)
	world_grid.scientist_spawn_position.global_position = path.global_position
