extends Control

var is_paused = false setget set_is_paused
func _unhandled_input(event):
	if Input.is_action_just_pressed("pause"):
		self.is_paused = not is_paused
		
func set_is_paused(new_pause_state):
		is_paused = new_pause_state
		get_tree().paused = is_paused
		visible = is_paused

func _on_ResumeBtn_pressed():
	self.is_paused = false

func _on_QuitBtn_pressed():
	get_tree().quit()
