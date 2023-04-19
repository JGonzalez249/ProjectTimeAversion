extends Area2D

signal loseGloves


func _on_loseGloves_body_entered(_body, _extra_arg_0):
	emit_signal("loseGloves")
	self.queue_free()
