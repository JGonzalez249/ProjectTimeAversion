extends Node

@onready var _sfx_players = get_children()
@onready var index = 0

func play_audio(resource_path):
	var node = _sfx_players[index]
	
	node.stream = load(resource_path)
	node.play()

	index += 1
	if index > _sfx_players.size() - 1:
		index = 0
