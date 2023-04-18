extends Area2D


func _ready():
	var dialogue_resource = preload("res://src/dialogue/Level_1Dialogue.tres")
	DialogueManager.show_example_dialogue_balloon(\
	"AI_talk", \
	dialogue_resource
	)
#	_level_1_say("first_talk", dialogue_resource)

#func _level_1_say(title: String, resource: DialogueResource) -> void:
#	var dialogue_line = yield(DialogueManager.get_next_dialogue_line(title, resource), "completed")
#	var dialogue_ballon = preload("res://addons/dialogue_manager/example_balloon/example_balloon.tscn")
#	var balls =  dialogue_ballon.instance()
#	balls.dialogue = dialogue_line
#	add_child(balls)
#	_level_1_say(yield(balls, "actioned"), resource)
