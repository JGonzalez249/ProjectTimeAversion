extends Area2D


signal on_ai_talks

func _on_Actionable_body_entered(body: KinematicBody2D):
	emit_signal("on_ai_talks")
	self.queue_free()
