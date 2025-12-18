extends Control

@onready var image: TextureRect = $HBoxContainer/VBoxContainer/Image
@onready var explanation: Label = $HBoxContainer/VBoxContainer/Explanation

var game_scene = preload("res://scenes/game/Game.tscn")

var images := [
	"res://assets/tutorial/1.png",
	"res://assets/tutorial/2.png",
	"res://assets/tutorial/3.png",
	"res://assets/tutorial/4.png",
	"res://assets/tutorial/5.png",
	"res://assets/tutorial/6.png",
	"res://assets/tutorial/7.png",
	"res://assets/tutorial/8.png",
]

var explanations := [
	"Bienvenue dans Polar Extreme ! Votre objectif est d'acculumer un total de [...] Science tout en respectant l'environnement et le bien-être des scientifiques.",
	"Pour générer de la science, vous devrez placer un laboratoire et y assigner un scientifique. Chaque laboratoire est défini par sa production par scientifique et sa capacité maximale en scientifique.",
	"Attention ! Vous n'avez pas des scientifiques en illimité. Pour en recruter de nouveaux, ouvrez le menu 'Gestion des scientifiques' et pressez 'Recruter un scientifique'. Les nouveaux arrivants arriveront en avion d'ici quelques secondes",
	"A force de travailler, vos scientifiques vont commencer à se fatiguer. Leur état est symbolisé par la jauge de bien-être. Afin de leur redonner le sourire, n'hésitez pas à construire des bâtiments tels qu'une salle de sport, une cantine, une salle de repos, etc...",
	"Les dortoirs, en plus d'améliorer le bien-être des scientifiques, permet d'augmenter le nombre maximum de scientifiques recrutables. Chaque dortoir correspond à [...] scientifiques.",
	"Enfin, l'activité de la base pollue. Pour compenser cela, pensez à investir dans des batîments techniques, comme une centrale électrique ou un centre de tri afin d'assurer le respect de l'environnement.",
	"Finalement, si vous n'avez plus de places pour poser un bâtiment, vous pouvez construire de nouveaux chemins. Il n'y aucune limite à ceux-ci.",
	"Au lancement de la partie, vous aurez dès le départ un scientifique, un laboratoire de glaciologie, et un dortoir. Bon jeu !"
]

var index := 0

func _ready():
	image.custom_minimum_size = Vector2(1280, 720)
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	explanation.offset_bottom += 100
	show_image(index)

func show_image(i: int):
	var texture := load(images[i]) as Texture2D
	image.texture = texture
	explanation.text = explanations[i]


func _on_next_btn_pressed() -> void:
	index = min(images.size() - 1,index + 1)
	if(index == images.size() - 1):
		get_tree().change_scene_to_packed(game_scene)
	else:
		show_image(index)


func _on_back_btn_pressed() -> void:
	index = min(0,index - 1)
	show_image(index)
