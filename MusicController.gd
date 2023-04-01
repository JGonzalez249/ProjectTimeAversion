extends Node

onready var musicPlayer = $Music

var menu_music = load("res://src/assets/audio/8bit-Smooth_Presentation.mp3")
var game_music = load("res://src/assets/audio/thinking-overture-115159.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _play_menu_music():
	musicPlayer.stream = menu_music
	musicPlayer.play()

func _play_game_music():
	musicPlayer.stream = game_music
	musicPlayer.play()
