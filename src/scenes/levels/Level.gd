extends Node2D

var dialogue_resource = preload("res://src/dialogue/Level_1Dialogue.tres")
var dialogue_resource2 = preload("res://src/dialogue/Level_2Dialogue.tres")
var dialogue_resource3 = preload("res://src/dialogue/Level_3Dialogue.tres")
var dialogue_resource4 = preload("res://src/dialogue/Level_4Dialogue.tres")

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


func _on_ClimbUp_body_entered(body, _extra_arg_0):
	if body.name == "Player":
		DialogueManager.show_example_dialogue_balloon("climb_wall1", dialogue_resource2)
		$ClimbUp.queue_free()



func _on_slowZone4_passedSlowZone(_extra_arg_0):
	if PlayerVariables.speed >= 0:
		PlayerVariables.speed -= PlayerVariables.LOWER_SPEED
		PlayerVariables.wall_climb_speed -= PlayerVariables.LOWER_CLIMB_SPEED
		DialogueManager.show_example_dialogue_balloon("AI_Talk", dialogue_resource4)


func _on_slowZone3_passedSlowZone(_extra_arg_0):
	if PlayerVariables.speed >= 0:
		PlayerVariables.speed -= PlayerVariables.LOWER_SPEED


func _on_NPC_Dialogue_body_entered(_body):
		DialogueManager.show_example_dialogue_balloon("dead_npc", dialogue_resource3)
		$NPC_Dialogue.queue_free()


func _on_loseGloves_body_entered(body, _extra_arg_0):
	if body.name == "Player":
		DialogueManager.show_example_dialogue_balloon("loseGloves", dialogue_resource4)
		$loseGloves.queue_free()


func _on_EndingArea_body_entered(body):
	if body.name == "Player":
		DialogueManager.show_example_dialogue_balloon("ending", dialogue_resource4)
		$EndingArea.queue_free()
