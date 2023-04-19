extends Node2D

var dialogue_resource = preload("res://src/dialogue/Level_1Dialogue.tres")
var dialogue_resource2 = preload("res://src/dialogue/Level_2Dialogue.tres")
var dialogue_resource3 = preload("res://src/dialogue/Level_3Dialogue.tres")

func _on_DoorToLevel_body_entered(body, _extra_arg_0) -> void:
	if body.name == "Player" and PlayerVariables._has_climbing_item and PlayerVariables._has_double_jump_item:
		LevelManager.changeLevel(LevelManager.LEVEL02)
		yield(get_node("/root/LevelManager").get_child(0), "animation_finished")
		PlayerVariables.blurStrength += 1
		GameStates.level += 1

func _on_DoorToLevel03_body_entered(body, _extra_arg_0) -> void:
	if body.name == "Player":
		LevelManager.changeLevel(LevelManager.LEVEL03)
		yield(get_node("/root/LevelManager").get_child(0), "animation_finished")
		PlayerVariables.blurStrength += 1
		GameStates.level += 1
		
		
func _on_DoorToLevel04_body_entered(body, _extra_arg_0):
	if body.name == "Player":
		#Add condition for speaking with AI before loading level_4
		LevelManager.changeLevel(LevelManager.LEVEL04)
		yield(get_node("/root/LevelManager").get_child(0), "animation_finished")
		PlayerVariables.blurStrength += 1
		GameStates.level += 1

func _on_DoorToLevel01_body_entered(body, _extra_arg_0) -> void:
	if body.name == "Player":
		DialogueManager.show_example_dialogue_balloon("cant_go_back", dialogue_resource2)
		$DoorToLevel01.queue_free()


func _on_slowZone_passedSlowZone(_extra_arg_0):
	if PlayerVariables.speed >= 0:
		PlayerVariables.speed -= PlayerVariables.LOWER_SPEED
		DialogueManager.show_example_dialogue_balloon("pass_the_zone", dialogue_resource2)

func _on_slowZone2_passedSlowZone(_extra_arg_0):
	if PlayerVariables.speed >= 0:
		PlayerVariables.speed -= PlayerVariables.LOWER_SPEED
		PlayerVariables.wall_climb_speed -= PlayerVariables.LOWER_CLIMB_SPEED


func _on_LeapOfFaith_body_entered(body, _extra_arg_0):
	if body.name == "Player":
		DialogueManager.show_example_dialogue_balloon("leap_of_faith", dialogue_resource2)
		$LeapOfFaith.queue_free()


func _on_Computer_body_entered(body, _extra_arg_0):
	if body.name == "Player":
		DialogueManager.show_example_dialogue_balloon("on_computer", dialogue_resource)
		$Computer.queue_free()


func _on_ClimbUp_body_entered(body, extra_arg_0):
	if body.name == "Player":
		DialogueManager.show_example_dialogue_balloon("climb_wall1", dialogue_resource2)
		$ClimbUp.queue_free()


func _on_DeadNPC_playerDetected(extra_arg_0):
	pass # Replace with function body.
