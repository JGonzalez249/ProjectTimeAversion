extends Node


func toggle_fullscreen(value):
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (value) else Window.MODE_WINDOWED
	Save.game_data.fullscreen_on = value
	Save.save_data()
	
func toggle_vsync(value):
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (value) else DisplayServer.VSYNC_DISABLED)
	Save.game_data.vsync_on = value
	Save.save_data()

func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, vol)
	Save.game_data.master_vol = vol
	Save.save_data()

func update_music_vol(vol):
	AudioServer.set_bus_volume_db(1, vol)
	Save.game_data.music_vol = vol
	Save.save_data()
	
func update_sfx_vol(vol):
	AudioServer.set_bus_volume_db(2, vol)
	Save.game_data.sfx_vol = vol
	Save.save_data()
