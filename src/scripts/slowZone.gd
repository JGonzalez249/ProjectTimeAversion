extends Area2D

signal passedSlowZone

# To be used throughout game to slow down player during progression/story 
#(may use % against current player speed when entering certain levels)
func _on_slowZone_body_entered(_body: KinematicBody2D):
	emit_signal("passedSlowZone")
	self.queue_free()
