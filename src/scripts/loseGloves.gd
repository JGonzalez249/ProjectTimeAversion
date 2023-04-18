extends Area2D

signal loseGloves


func _on_loseGloves_body_entered(body, _extra_arg_0):
	print("lost gloves")
	emit_signal("loseGloves")
	self.queue_free()
