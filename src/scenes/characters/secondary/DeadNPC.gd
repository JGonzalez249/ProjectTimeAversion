extends Node2D

signal playerDetected

func _on_DetectPlayer_body_entered(body: KinematicBody2D):
	if body.name == "Player":
		print("oh, dead body")
		emit_signal("playerDetected")
	else:
		print("no body?")
	
