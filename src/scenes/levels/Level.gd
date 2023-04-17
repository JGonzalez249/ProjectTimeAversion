extends Node2D

func _on_DoorToLevel_body_entered(body) -> void:
	if body.name == "Player" and PlayerVariables._has_climbing_item and PlayerVariables._has_double_jump_item:
		LevelManager.changeLevel(LevelManager.LEVEL02)
		yield(get_node("/root/LevelManager").get_child(0), "animation_finished")
		PlayerVariables.blurStrength += 1
	else:
		#Dialogue
		print("Need items to advance!")

func _on_DoorToLevel03_body_entered(body, _extra_arg_0) -> void:
	if body.name == "Player":
		LevelManager.changeLevel(LevelManager.LEVEL03)
		yield(get_node("/root/LevelManager").get_child(0), "animation_finished")
		PlayerVariables.blurStrength += 1
		
		
func _on_DoorToLevel04_body_entered(body, extra_arg_0):
	if body.name == "Player":
		#Add condition for speaking with AI before loading level_4
		LevelManager.changeLevel(LevelManager.LEVEL04)
		yield(get_node("/root/LevelManager").get_child(0), "animation_finished")
		PlayerVariables.blurStrength += 1

func _on_DoorToLevel01_body_entered(body, _extra_arg_0) -> void:
	if body.name == "Player":
		# Dialogue
		print("Can't go back, like in life!")


func _on_slowZone_passedSlowZone(_extra_arg_0):
	if PlayerVariables.speed >= 0:
		PlayerVariables.speed -= PlayerVariables.LOWER_SPEED

func _on_slowZone2_passedSlowZone(_extra_arg_0):
	 if PlayerVariables.speed >= 0:
			PlayerVariables.speed -= PlayerVariables.LOWER_SPEED # I have no idea why it wants this intentation????
		PlayerVariables.wall_climb_speed -= PlayerVariables.LOWER_CLIMB_SPEED




