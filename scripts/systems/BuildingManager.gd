extends Node
class_name BuildingManager

static var building_descriptions = [
	"Ce laboratoire est consacré à l’étude de la glace, de la neige et des glaciers. Les scientifiques y analysent des carottes de glace qui contiennent des bulles d’air très anciennes. Ces bulles permettent de connaître la composition de l’atmosphère et le climat de la Terre il y a des milliers, voire des centaines de milliers d’années.",
	"Dans ce bâtiment, les chercheurs étudient l’atmosphère, les nuages et les vents. Ils utilisent des capteurs et des instruments pour mesurer la température, l’humidité et la pollution. Ces recherches aident à mieux comprendre le changement climatique et à améliorer les prévisions météorologiques.",
	"Ce laboratoire observe les vibrations du sol et les variations du champ magnétique terrestre. Grâce à des instruments très sensibles, les scientifiques peuvent détecter des séismes très lointains. Ces données sont essentielles pour comprendre la structure interne de la Terre et les mouvements des plaques tectoniques.",
	"Ici, les chercheurs étudient la manière dont le corps humain réagit à des conditions extrêmes comme le froid intense, l’isolement ou le manque de lumière. Les résultats servent à améliorer la sécurité des scientifiques, mais aussi à préparer des missions spatiales de longue durée.",
	"La mine de glace permet d’extraire des blocs et des échantillons de glace très ancienne. Cette glace peut avoir plusieurs milliers d’années et contient des informations précieuses sur l’histoire du climat. L’environnement souterrain protège aussi les échantillons de la contamination extérieure.",
	"La serre est un espace contrôlé où l’on cultive des plantes malgré le climat hostile. Grâce à la lumière artificielle et à une température stable, elle fournit des légumes frais toute l’année. Elle joue aussi un rôle important pour le bien-être psychologique des habitants.",
	
	"Le dortoir est conçu pour offrir confort et repos dans un environnement extrême. Il est fortement isolé pour conserver la chaleur et réduire le bruit. Un bon sommeil est essentiel pour maintenir la santé et l’efficacité du personnel.",
	"La cantine est le lieu où le personnel se retrouve pour les repas. Les menus sont riches en énergie afin de répondre aux besoins physiques élevés liés au froid. C’est aussi un espace social important qui favorise la cohésion du groupe.",
	"Les douches sont gérées de manière très précise afin d’économiser l’eau. Les utilisateurs doivent respecter des temps limités. L’eau utilisée est ensuite récupérée pour être recyclée.",
	"Les toilettes sont équipées de systèmes spéciaux pour traiter les déchets humains sans polluer l’environnement. Les déchets sont transformés ou stockés de façon sécurisée, conformément aux règles écologiques strictes.",
	"La salle de détente est un espace destiné au repos et aux loisirs. On peut y lire, regarder des films ou discuter avec les autres membres de la base. Elle est essentielle pour réduire le stress et l’isolement.",
	"La salle de sport permet au personnel de rester en bonne santé physique. L’activité physique régulière aide aussi à lutter contre la fatigue mentale et le stress liés à la vie en milieu isolé.",
	
	"Dans cette zone, tous les déchets sont soigneusement triés. Les matériaux recyclables sont séparés des déchets dangereux. Ce système permet de réduire fortement l’impact environnemental de la base.",
	"Cette installation traite l’eau usée afin de la rendre à nouveau utilisable. L’eau peut être filtrée et purifiée plusieurs fois, ce qui permet de limiter les besoins en nouvelles ressources.",
	"La centrale électrique fournit l’énergie nécessaire au fonctionnement de l’ensemble du site. Elle fonctionne en continu et peut combiner plusieurs sources d’énergie pour garantir une alimentation fiable, même dans des conditions extrêmes.",
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
