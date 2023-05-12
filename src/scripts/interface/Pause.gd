extends Control


@onready var _focusButton: Button = find_child("ResumeBtn")
#@onready var _settings_menu: Popup = $Settings

var is_paused = false: set = set_is_paused

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause"):
		self.is_paused = not is_paused

func set_is_paused(new_pause_state):
	is_paused = new_pause_state
	get_tree().paused = is_paused
	visible = is_paused
	_focusButton.grab_focus()
	if is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_ResumeBtn_pressed():
	self.is_paused = false

func _on_QuitBtn_pressed():
	get_tree().quit()

#func _on_SettingsBtn_pressed():
#	_settings_menu.popup_centered()

func _on_ReturnBtn_pressed():
	self.is_paused = not is_paused
	LevelManager.changeLevel(LevelManager.LEVEL00)
