extends CanvasLayer

const LEVEL01 = ("res://src/scenes/levels/Level01.tscn")
#const LEVEL02
#const LEVEL03
#const LEVEL04

func changeLevel(level_path):
	get_tree().change_scene(level_path)
