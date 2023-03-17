extends Area2D

signal loseDoubleJumpZone

# When player enters this zone, max_jumps =- 1
func _on_loseDoubleJump_body_entered(_body: KinematicBody2D):
	print("You lost your double jump!")
	emit_signal("loseDoubleJumpZone")
	self.queue_free()
