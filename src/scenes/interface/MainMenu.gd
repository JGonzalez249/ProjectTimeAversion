extends Control

onready var _focusButton: Button = $Menu/StartGameBtn

# Called when the node enters the scene tree for the first time.
func _ready():
	_focusButton.grab_focus()


func _on_StartGameBtn_pressed():
	get_tree().change_scene("res://src/scenes/levels/Main.tscn")


func _on_OptionsBtn_pressed():
	pass # Replace with function body.


func _on_QuitGameBtn_pressed():
	get_tree().quit()
