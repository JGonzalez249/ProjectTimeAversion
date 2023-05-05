extends Area2D

signal passedSlowZone


# To be used throughout game to slow down player during progression/story 
func _on_slowZone_body_entered(_body: CharacterBody2D):
	emit_signal("passedSlowZone")
	self.queue_free()

