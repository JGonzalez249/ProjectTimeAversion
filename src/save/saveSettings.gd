extends Node

const SAVEFILE = "user://SAVEFILE.save"

var game_data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()


func load_data():
	var file = File.new()
	if not file.file_exists(SAVEFILE):
		game_data = {
			"fullscreen_on": false,
			"vsync_on": false,
			"master_vol": -10,
			"music_vol": -10,
			"sfx_vol": -10
		}
		save_data()
	file.open(SAVEFILE, File.READ)
	game_data = file.get_var()
	file.close()

func save_data():
	var file = File.new()
	file.open(SAVEFILE, file.WRITE)
	file.store_var(game_data)
	file.close()
