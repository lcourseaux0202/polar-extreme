extends Node
class_name ScientistFactory
## Factory class for creating Scientist instances.
##
## Implements the Factory pattern to centralize scientist creation logic.
## Loads and instantiates the Scientist scene, providing a single point
## of control for scientist object creation throughout the game.

## Path to the Scientist scene file
const SCIENTIST_PATH: String = "res://scenes/scientist/Scientist.tscn"


## Creates and returns a new Scientist instance.
## Loads the scientist scene and instantiates it as a new node.
## [return] Newly instantiated Scientist object
func make_scientist() -> Scientist:
	var scene = load(SCIENTIST_PATH).instantiate()	
	return scene
