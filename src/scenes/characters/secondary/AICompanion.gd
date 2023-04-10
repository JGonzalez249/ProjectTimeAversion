extends Node2D

onready var _animateAI: AnimationPlayer = $AnimationPlayer
onready var _sprite: Sprite = $KinematicBody2D/Sprite
onready var _aiNPCPos: KinematicBody2D = $KinematicBody2D


export var offsetX: int = 0
export var offsetY: int = 0

func _process(_delta):
	_animateAI.play("Float")
#	currentPos()
#
#
#func currentPos():
#	if LevelManager.LEVEL01:
#		_aiNPCPos.transform2D = Vector2(offsetX, offsetY)
