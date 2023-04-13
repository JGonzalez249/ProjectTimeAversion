extends Node2D

func _on_DoorToLevel_body_entered(body) -> void:
	if body.name == "Player" and PlayerVariables._has_climbing_item and PlayerVariables._has_double_jump_item:
		LevelManager.changeLevel(LevelManager.LEVEL02)
		PlayerVariables.blurStrength += 1
	else:
		#Dialogue
		print("Need items to advance!")


func _on_DoorToLevel01_body_entered(body, _extra_arg_0) -> void:
	if body.name == "Player":
		# Dialogue
		print("Can't go back, like in life!")

func _level_pos_y_offset(y):
	if LevelManager.LEVEL02:
		PlayerVariables.position.y = -10
