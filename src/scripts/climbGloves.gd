extends Area2D

signal onGlovePickup

# An ability pickup, emits signal to player to set _wall_climb = true
func _on_climbGloves_body_entered(_body: CharacterBody2D):
	emit_signal("onGlovePickup")
	self.queue_free()
