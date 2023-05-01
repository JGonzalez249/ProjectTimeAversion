extends Control

onready var _focusButton: Button = $Menu/StartGameBtn
onready var _settings_menu: Popup = $Settings

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables.blurStrength = 0
	PlayerVariables.speed = 450
	MusicController._play_menu_music()
	_focusButton.grab_focus()


func _on_StartGameBtn_pressed():
	# warning-ignore:return_value_discarded
	MusicController._play_game_music()
	LevelManager.changeLevel(LevelManager.LEVEL01)
	GameStates.level += 1


func _on_SettingsBtn_pressed():
	_settings_menu.popup_centered()


func _on_QuitGameBtn_pressed():
	get_tree().quit()
