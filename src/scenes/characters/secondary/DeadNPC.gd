extends Node2D

signal playerDetected

func _on_DetectPlayer_body_entered(body):
	emit_signal("signal playerDetected")
	
