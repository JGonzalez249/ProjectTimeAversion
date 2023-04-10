extends Node2D



func _on_DoorToLevel_body_entered(body) -> void:
	if body.name == "Player":
		LevelManager.changeLevel(LevelManager.LEVEL02)
