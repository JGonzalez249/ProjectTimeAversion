extends Node2D

var dialogue_resource = preload("res://src/dialogue/Level01.dialogue")
var dialogue_resource2 = preload("res://src/dialogue/Level02.dialogue")
var dialogue_resource3 = preload("res://src/dialogue/Level03.dialogue")
var dialogue_resource4 = preload("res://src/dialogue/Level04.dialogue")
var ending_anim = preload("res://src/scenes/levels/ending.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_DoorToLevel_body_entered(body, _extra_arg_0) -> void:
	if body.name == "Player" and PlayerVariables._has_climbing_item and PlayerVariables._has_double_jump_item:
		LevelManager.changeLevel(LevelManager.LEVEL02)
		await get_node("/root/LevelManager").get_child(0).animation_finished
		PlayerVariables.blurStrength += 1
		GameStates.level += 1

func _on_DoorToLevel03_body_entered(body, _extra_arg_0) -> void:
	if body.name == "Player":
		LevelManager.changeLevel(LevelManager.LEVEL03)
		await get_node("/root/LevelManager").get_child(0).animation_finished
		PlayerVariables.blurStrength += 1
		GameStates.level += 1
		
		
func _on_DoorToLevel04_body_entered(body, _extra_arg_0):
	if body.name == "Player":
		#Add condition for speaking with AI before loading level_4
		LevelManager.changeLevel(LevelManager.LEVEL04)
		await get_node("/root/LevelManager").get_child(0).animation_finished
		PlayerVariables.blurStrength += 1
		GameStates.level += 1

func _on_DoorToLevel01_body_entered(body, _extra_arg_0) -> void:
	if body.name == "Player":
		DialogueManager.show_example_dialogue_balloon(dialogue_resource2, "cant_go_back")
		$DoorToLevel01.queue_free()


func _on_slowZone_passedSlowZone(_extra_arg_0):
	if PlayerVariables.speed >= 0:
		PlayerVariables.speed -= PlayerVariables.LOWER_SPEED
		DialogueManager.show_example_dialogue_balloon(dialogue_resource2, "pass_the_zone")

func _on_slowZone2_passedSlowZone(_extra_arg_0):
	if PlayerVariables.speed >= 0:
		PlayerVariables.speed -= PlayerVariables.LOWER_SPEED
		PlayerVariables.wall_climb_speed -= PlayerVariables.LOWER_CLIMB_SPEED


func _on_LeapOfFaith_body_entered(body, _extra_arg_0):
	if body.name == "Player":
		DialogueManager.show_example_dialogue_balloon(dialogue_resource2, "leap_of_faith")
		$LeapOfFaith.queue_free()


func _on_Computer_body_entered(body, _extra_arg_0):
	if body.name == "Player":
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, "on_computer")
		$Computer.queue_free()


func _on_ClimbUp_body_entered(body, _extra_arg_0):
	if body.name == "Player":
		DialogueManager.show_example_dialogue_balloon(dialogue_resource2, "climb_wall1")
		$ClimbUp.queue_free()



func _on_slowZone4_passedSlowZone(_extra_arg_0):
	if PlayerVariables.speed >= 0:
		PlayerVariables.speed -= PlayerVariables.LOWER_SPEED
		PlayerVariables.wall_climb_speed -= PlayerVariables.LOWER_CLIMB_SPEED
		DialogueManager.show_example_dialogue_balloon(dialogue_resource4,"AI_Talk")


func _on_slowZone3_passedSlowZone(_extra_arg_0):
	if PlayerVariables.speed >= 0:
		PlayerVariables.speed -= PlayerVariables.LOWER_SPEED


func _on_NPC_Dialogue_body_entered(_body):
		DialogueManager.show_example_dialogue_balloon(dialogue_resource3, "dead_npc")
		$NPC_Dialogue.queue_free()


func _on_loseGloves_body_entered(body, _extra_arg_0):
	if body.name == "Player":
		DialogueManager.show_example_dialogue_balloon(dialogue_resource4, "loseGloves")
		$loseGloves.queue_free()


func _on_EndingArea_body_entered(body):
	if body.name == "Player":
		DialogueManager.show_example_dialogue_balloon(dialogue_resource4, "ending")
		$EndingArea.queue_free()

