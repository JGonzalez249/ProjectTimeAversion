extends Area2D

signal onDoubleJumpPickup

# Disappears once player enters collision, emits signal to player to increase max_jumps by 1
func _on_doubleJump_body_entered(_body: KinematicBody2D):
	print("You picked up the rocket boots!")
	emit_signal("onDoubleJumpPickup")
	self.queue_free()
