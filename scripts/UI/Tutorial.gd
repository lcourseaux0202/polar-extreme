extends Control

@onready var image: TextureRect = $HBoxContainer/VBoxContainer/Image
@onready var explanation: Label = $HBoxContainer/VBoxContainer/Explanation

@export_enum("NORMAL", "SHORT") var mode = "SHORT"

var game_scene = preload("res://scenes/game/Game.tscn")

var images := [
	"res://assets/others/Logo.png",
	"res://assets/tutorial/menu_bat.png",
	"res://assets/tutorial/menu_bat.png",
	"res://assets/tutorial/menu_info_bat.png",
	"res://assets/tutorial/projet_info.png",
	"res://assets/tutorial/menu_projets.png",
	"res://assets/tutorial/menu_projets.png",
	"res://assets/tutorial/menu_scientifique.png",
	"res://assets/tutorial/menu_scientifique.png",
	"res://assets/tutorial/menu_scientifique.png",
	"res://assets/tutorial/science.png",
	"res://assets/tutorial/science.png",
]

var images_short := [
	"res://assets/others/Logo.png",
	"res://assets/tutorial/menu_bat.png",
	"res://assets/tutorial/menu_scientifique.png",
	"res://assets/tutorial/science.png",
]

var explanations := [
	"Bienvenue dans Polar Extreme ! Votre objectif est d'accumuler un maximum de Science en un minimum de temps tout en respectant l'environnement et le bien-être des scientifiques.",
	"Ce menu permet de construire les divers bâtiments ainsi que les chemins. Le premier bouton permet de placer les chemins, vous pouvez en avoir autant que vous voulez !",
	"Les 3 autres boutons ouvrent les différentes catégories de bâtiments. De gauche à droite, nous avons : les laboratoires pour produire de la science, les batîments de vie commune pour rendre heureux vos scientifiques, les bâtiments techniques pour réduire la pollutiion.",
	"Une fois un bâtiment placé, vous pouvez cliquer dessus pour ouvrir le menu d'informations du bâtiments. Vous y trouverez son nom, qu'est-ce que le bâtiment apporte, et la liste des projets si c'est un laboratoire.",
	"En cliquant sur un projet, vous pourrez le démarrer si vous possédez suffisant de scientifiques libres (qui ne sont pas assignés à un laboratoire / projet)",
	"Une fois le projet démarré, il sera ajouter dans la liste de tous les projets dans le bouton à gauche.",
	"Quand un projet se termine, toutes les récompenses qui lui sont lié sont récupérées automatiquement.",
	"Dans ce menu, vous pouvez recruter des scientifiques. Pour cela, il faut avoir assez de sciences et de lits.",
	"Chaque scientifique arrive en avion, augmentant ainsi la pollution dans l'air. Aussi, plus vous avez de scientifiques, plus ils vont se sentir à l'étroit et se sentir mal. Construisez des bâtiments de vie communes et techniques pour palier à ces problèmes.",
	"Vous trouverez aussi dans ce menu une liste de tous les laboratoires afin de faciliter l'assignation de scientifique.",
	"Enfin, en haut à gauche vous verrez votre stock de science et votre production par secondes",
	"Désormais, vous connaissez tout qu'il faut pour lancer la partie, alors bon jeu !"
]

var explanations_short := [
	"Bienvenue dans Polar Extreme ! Votre objectif est d'accumuler un maximum de Science en un minimum de temps tout en respectant l'environnement et le bien-être des scientifiques.",
	"Construisez des laboratoires, des bâtiments de vie commune, ou des bâtiments techniques afin de réguler respectivement votre production de science, le bien-être des scientifiques, et la pollution.",
	"Pour commencer à produire, assignez des scientifiques aux divers laboratoires.",
	"Si vous vous sentez perdu en jeu, cliquez sur ce bouton pour obtenir plus d'informations.",
]


var index := 0

func _ready():
	image.custom_minimum_size = Vector2(1280, 720)
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	explanation.offset_bottom += 100
	show_image(index)

func show_image(i: int):
	if mode == "SHORT": 
		var texture := load(images_short[i]) as Texture2D
		image.texture = texture
		explanation.text = explanations_short[i]
	else :
		var texture := load(images[i]) as Texture2D
		image.texture = texture
		explanation.text = explanations[i]


func _on_next_btn_pressed() -> void:
	if mode == "SHORT":
		index = min(images_short.size(),index + 1)
		if(index == images_short.size()):
			get_tree().change_scene_to_packed(game_scene)
		else:
			show_image(index)
	else :
		index = min(images.size(),index + 1)
		if(index == images.size()):
			visible = false
		else:
			show_image(index)


func _on_back_btn_pressed() -> void:
	index = min(0,index - 1)
	show_image(index)


func _on_skip_btn_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
