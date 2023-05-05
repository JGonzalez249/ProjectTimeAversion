extends Node2D

signal playerDetected

func _on_DetectPlayer_body_entered(body: CharacterBody2D):
	if body.name == "Player":
		emit_signal("playerDetected")

