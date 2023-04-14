# This script ca be used to influence the game world and provides overall progression
#Currently not in  use
extends Node2D
export var game_scene:String
var game_world:Node2D



func _on_Game_starting():
	
	var game_world_scene=load(game_scene)
	game_world=game_world_scene.instance()
	add_child(game_world)
	
	game_world.connect("end_game", self, "open_main_menu")


func open_main_menu():
	game_world.queue_free()
	get_tree().paused=false
	
	var main_menu=load("res://src/scenes/interface/MainMenu.tscn")
	add_child(main_menu)
	main_menu.connect("starting", self, "_on_Game_starting")
