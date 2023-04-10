extends Control


onready var _focusButton: Button = $CenterContainer/Menu/ResumeBtn
onready var _settings_menu: Popup = $Settings

var is_paused = false setget set_is_paused
func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause"):
		self.is_paused = not is_paused
		
func set_is_paused(new_pause_state):
		is_paused = new_pause_state
		get_tree().paused = is_paused
		visible = is_paused
		_focusButton.grab_focus()

func _on_ResumeBtn_pressed():
	self.is_paused = false

func _on_QuitBtn_pressed():
	get_tree().quit()

func _on_SettingsBtn_pressed():
	_settings_menu.popup_centered()
