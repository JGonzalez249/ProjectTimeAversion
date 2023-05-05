extends CanvasLayer

@onready var LEVEL00 = ("res://src/scenes/interface/MainMenu.tscn")
@onready var LEVEL01 = ("res://src/scenes/levels/level_1.tscn")
@onready var LEVEL02 = ("res://src/scenes/levels/level_2.tscn")
@onready var LEVEL03 = ("res://src/scenes/levels/level_3.tscn")
@onready var LEVEL04 =  ("res://src/scenes/levels/level_4.tscn")

func _ready():
	get_node("ColorRect").hide()
	get_node("Label").hide()
	get_node("CenterContainer").hide()

func changeLevel(level_path):
	get_node("ColorRect").show()
	get_node("Label").show()
	get_node("Anim").play("TransIn")
	await get_node("Anim").animation_finished

# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file(level_path)

	get_node("Anim").play("TransOut")
	await get_node("Anim").animation_finished
	get_node("ColorRect").hide()
	
	
func play_ending():
	get_node("ColorRect").show()
	get_node("CenterContainer").show()
	get_node("Anim").play("levelsFadeInEnd")
	await get_node("Anim").animation_finished
	changeLevel(LEVEL00)
