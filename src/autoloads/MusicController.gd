extends Node

onready var _musicPlayer = $Music

var menu_music = load("res://src/assets/audio/music/8bit-Smooth_Presentation.mp3")
var game_music = load("res://src/assets/audio/music/thinking-overture-115159.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _play_menu_music():
	_stop()
	_musicPlayer.stream = menu_music
	_musicPlayer.play()

func _play_game_music():
	_stop()
	_musicPlayer.stream = game_music
	_musicPlayer.play()

func _stop():
	_musicPlayer.stop()
