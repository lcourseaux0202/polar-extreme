extends Node
class_name BuildingManager

static var building_descriptions = [
	"La tranchée « froide » est un bâtiment séparé en deux espaces.La première zone sert à stocker temporairement des carottes de glace.Les espaces plus en arrière servaient à scier, échantillonner et réaliser une première spectrométrie des carottes.",
	"Il est composé d’un shelter en bois qui abrite les espaces de travail des scientifiques, un espace avec le matériel nécessaire pour bricoler les télescopes, des ordinateurs, un serveur de stockage et de transfert des données acquises par les télescopes.Il y a également des dômes accueillant les télescopes et un petit shelter de contrôle des instruments installés.",
	"Une structure isolée, sans métal, souvent enterrée. Il enregistre les plus infimes vibrations de la Terre et les variations du champ magnétique, loin du bruit humain",
	"Le laboratoire de biologie humaine situé à la station Concordia en Antarctique est dédié à l'étude de l'adaptation humaine aux conditions extrêmes d'isolement de confinement et de climat sévère, en lien avec les missions spatiales futures.",
	"Une importante campagne de forage en Antarctique a permis d'atteindre une carotte de glace datant d'au moins 1,2 million d'années, marquant un progrès majeur dans l'étude du climat passé.",
	"Une serre est actuellement en cours d'installation à proximité du pôle Sud en Antarctique,marquant la première infrastructure de ce type sur le continent. Ce projet, mené par l'Université d'Arizona, vise à cultiver des légumes comme la laitue, les épinards et les fraises pour les chercheurs isolés à la Station de recherche Amundsen Scott",
	"Les conditions de vie sont extrêmes, avec des vents pouvant dépasser 100 km/h et une nuit polaire prolongée,mais la station est équipée de systèmes de chauffage, de communication et de production d’eau pour assurer la survie et le confort des scientifiques.",
	"Équipée de vélos, tapis de course et poids. Indispensable pour lutter contre l'atrophie musculaire et la baisse de moral induites par le confinement et le froid",
	"Les douches recyclantes,une technologie innovante pour la gestion des eaux usées, ont été développées dans le cadre de recherches menées pour des stations polaires, notamment en Antarctique. Cette technologie vient de l'Agence Spatiale Européenne.",
	"En Antarctique, les installations sanitaires varient selon le type d'activité, que ce soit pour des expéditions personnelles, des stations de recherche ou des croisières.Les besoins sont gérés en creusant un trou à l'entrée de la tente, qui gèle rapidement, ou en utilisant une « gourde pipi » pour éviter de sortir la nuit.",
	"Cette sale est essentielle pour le bien être des scientifiques,on peut y retrouver une bibiliothéque,une Tv ,des handSpinners ,un billard, un babyfoot,une prostituéeun bar a salade polonaise,un bon pc pour jouer a cyberpunk 2077.Sert de lieu de rassemblement pour les membres de l'équipe, notamment lors des briefings hebdomadaires.",
	"Équipée de vélos, tapis de course et poids. Indispensable pour lutter contre l'atrophie musculaire et la baisse de moral induites par le confinement et le froid.",
	"Salle technique stricte avec des bacs de couleurs. Chaque type de déchet (organique, plastique, métal, dangereux) y est scrupuleusement séparé pour un traitement adapté.",
	"La station est pourvue de deux systèmes d’approvisionnement en eau. Une eau « fraîche » est produite par fonte de glace(4 conteneurs/cuves de 20m)de cette eau sont stockés : filtrée, traitée par osmose et rayons UV, elle est potable et sert à la cuisine, à l’eau de boisson.",
	"Le battement de cœur bruyant et chaud de la base. Abritant les générateurs, c'est la source d'énergie pour la chaleur, la lumière, la science et la communication."
]

var building_factory = load("res://scripts/factories/BuildingFactory.gd").new()
var path_factory = load("res://scripts/factories/PathFactory.gd").new()
var buildingsIds := {}

var building_counter := 0
var hovered_building : Building = null

var buildings_list : Array[Building]= []
var buildings_positions := []

func create_building(btype : Enums.BUILDING_TYPE) -> Building:
	var building : Building = building_factory.create_building(btype)
	building.name = "Building" + str(building_counter)
	
	var plist = GameController.get_projects_manager().get_list(btype, building)
	if plist and building.has_method("set_projects"):
		building.set_projects(plist)
		print("ajoute la liste")
		print(str(btype) + building.name)
		print("\n")
		
	return building

func create_path() -> Path:
	var path = path_factory.create_path()
	return path

func register(building : Building):
	building_counter += 1
	var type = building.get_building_type()
	buildings_positions.append(building.get_door_position())
	buildings_list.append(building)
	
func unregister(building:Building):
	var type = building.get_building_type()
	buildings_positions[type].erase(building)
	
func get_building(id :int) -> Building:
	return buildingsIds[id]

func get_building_list() -> Array[Building]:
	return buildings_list

func get_random_building_position() -> Vector2:
	if buildings_positions.size() != 0:
		return buildings_positions.pick_random()
	else :
		return Vector2(0,0)
		
func get_building_description(btype : Enums.BUILDING_TYPE) -> String :
	return building_descriptions[btype]
	#var key = buildings_positions.keys().pick_random()
	#return buildings_positions[key].pick_random()
	
func get_free_spaces() -> int:
	var spaces = 0
	print(buildings_list)
	for b in buildings_list:
		spaces += b.scientist_places
	return spaces
