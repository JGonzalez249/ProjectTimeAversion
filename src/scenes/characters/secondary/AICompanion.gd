extends Node2D

onready var _animateAI: AnimationPlayer = $AnimationPlayer


func _process(delta):
	_animateAI.play("Float")

