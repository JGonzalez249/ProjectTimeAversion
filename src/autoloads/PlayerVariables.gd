extends Node2D

const LOWER_SPEED: int = 75
const LOWER_CLIMB_SPEED: int = 50

var max_jumps: int = 1 
var max_wall_jumps: int = 1
var _jumps_made: int = 0
var _has_double_jump_item: bool = false #Start false
var _has_climbing_item: bool = false #Start false
var _can_double_jump: bool = false #Start false
var _wall_slide: bool = true
var _can_wall_jump: bool = false

var slowSpeedZone: int = 0
var blurStrength: int = 0
var wall_climb_gravity: int = 0

@export var speed: int = 450 #450
@export var gravity: int = 35
@export var jump_strength: int = -1000
@export var double_jump_strength: int = -800
@export var wall_slide_speed: int = 75
@export var wall_slide_gravity: int = 1800
@export var wall_climb_speed:int = 150
@export var wall_jump_strength: int = -650
@export var wall_pushback: int = 1000

