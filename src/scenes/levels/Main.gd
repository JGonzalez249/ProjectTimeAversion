# This script is used to influence the game world and provides overall progression


extends Node2D

var _is_paused: bool = false

func _ready():
	pass # Replace with function body.


func _mouse_cursor_behavior():
	 if _is_paused:
		pass
