extends Popup


# Video Settings
@onready var _display_options: OptionButton = find_child("DisplayOption")
@onready var _vsync_mode: CheckButton = find_child("VSyncBtn")

# Audio Settings
@onready var _master_slider =  $SettingTabs/Audio/MarginContainer/AudioSettings/MasterVolSlider
@onready var _music_slider = $SettingTabs/Audio/MarginContainer/AudioSettings/MusicVolSlider
@onready var _sfx_slider =  $SettingTabs/Audio/MarginContainer/AudioSettings/SFXVolSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	_display_options.select(1 if Save.game_data.fullscreen_on else 0)
	GlobalSettings.toggle_fullscreen(Save.game_data.fullscreen_on)
	_vsync_mode.button_pressed = Save.game_data.vsync_on
	_master_slider.value = Save.game_data.master_vol
	_music_slider.value = Save.game_data.music_vol
	_sfx_slider.value = Save.game_data.sfx_vol



func _on_DisplayOption_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index==1 else false)


func _on_VSyncBtn_toggled(button_pressed):
	GlobalSettings.toggle_vsync(button_pressed)


func _on_MasterVolSlider_value_changed(value):
	GlobalSettings.update_master_vol(value)


func _on_MusicVolSlider_value_changed(value):
	GlobalSettings.update_music_vol(value)


func _on_SFXVolSlider_value_changed(value):
	GlobalSettings.update_sfx_vol(value)
	
