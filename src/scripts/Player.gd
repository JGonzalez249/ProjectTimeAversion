#TODO: make the player climb up a wall when they have the gloves (x)
#TODO: make a zone that slows the player (X) <--- instanciate for level progression
#TODO: make a dedicated wall_jump () <--- to be replaced possibly by grapple after certain progression
#TODO: make a ledge grab ()  <--- useful for possible future grapple, may need apply to climbable walls
#TODO: limit player vision as they progress ()


extends KinematicBody2D
 
enum States {FALLING = 1, DOUBLE_JUMP, FLOOR, WALL, CLIMB} 
var state = States.FALLING

var UP_DIRECTION := Vector2.UP

var screen_size

export var speed := 450
export var gravity := 35
export var jump_strength := -800
export var double_jump_strength := -800
export var wall_slide_speed := 75
export var wall_slide_gravity := 1800
export var wall_climb_speed := 100
export var wall_jump_strength := 1000
export var wall_pushback := 500
var wall_climb_gravity := 0

const SLOW_SPEED := 75

# Maximum number of jumps that player can make, 
# change value +1 when picking up rocket boots, -1 when losing rocket boots
var max_jumps := 1 
var max_wall_jumps := 1 

var _jumps_made := 0
var _wall_jumps_made := 0
var _velocity := Vector2.ZERO


#  Bools for conditions
var _has_double_jump_item := false
var _has_climbing_item := false
var _can_double_jump := false
var _wall_slide := true
var _can_wall_jump := false
var _wall_climb :=  false


onready var _pivot: Node2D = $Pivot2D
onready var _sprite: AnimatedSprite = $Sprite
onready var _raycast: RayCast2D = $Pivot2D/WallRay/ #<--- To be used for wall climbing and sliding
onready var _ledgeRay: RayCast2D = $Pivot2D/LedgeRay
onready var _ledgeRayHori: RayCast2D = $Pivot2D/LedgeRayHori
onready var _start_scale: Vector2 = _pivot.scale



func _ready():
	screen_size = get_viewport_rect().size # Gets screen size and scales assets

func _physics_process(delta: float) -> void:
	print(state)
		# Variables for conditions
	var is_falling := _velocity.y > 0.0 and not is_on_floor()
	var is_jumping :=  Input.is_action_just_pressed("jump") and is_on_floor()
	var is_ledge_climbing := is_on_ledge() and Input.is_action_pressed("up")
	
		# Get vertical movement from player <--- For wall climbing
	var _vertical_direction = (
		Input.get_action_strength("down")
		- Input.get_action_strength("up")
	)
	
	match state:
		States.FALLING:
			if is_on_floor():
				state = States.FLOOR
				continue
			if on_the_wall():
				state = States.WALL
				continue
			if on_climbable_wall() and _has_climbing_item:
				state = States.CLIMB
				continue
			if is_falling and _has_double_jump_item:
				state = States.DOUBLE_JUMP
				continue
			if is_falling:
				_sprite.play("Falling")
			player_mov()
			move_and_fall()
		States.DOUBLE_JUMP:
			if is_on_floor():
				state = States.FLOOR
				continue
			if on_the_wall():
				state = States.WALL
				continue
			if Input.is_action_pressed("jump") and _jumps_made < max_jumps:
				_jumps_made += 1
				_sprite.play("JumpAll")
				_velocity.y = double_jump_strength
				state = States.FALLING
			player_mov()
			move_and_fall()
		States.FLOOR:
			_jumps_made = 0
			if not is_on_floor():
				state = States.FALLING
			if Input.is_action_pressed("left"):
				_sprite.play("Run")
				_velocity.x = lerp(_velocity.x, -speed, 0.1) 
				_sprite.flip_h = true
			elif Input.is_action_pressed("right"):
				_sprite.play("Run")
				_velocity.x = lerp(_velocity.x, speed, 0.1)
				_sprite.flip_h = false
			else:
				_sprite.play("Idle")
				_velocity.x = lerp(_velocity.x, 0, 0.9)
			if is_jumping:
				_sprite.play("JumpAll")
				_velocity.y = jump_strength
				_jumps_made += 1
				state = States.FALLING
			move_and_fall()
		States.WALL:
			if is_on_floor():
				state = States.FLOOR
				continue
			if not is_on_floor() and not on_the_wall():
				state = States.FALLING
				continue
			if on_climbable_wall() and _has_climbing_item:
				state =  States.CLIMB
				continue
			if on_the_wall():
				if _raycast.is_colliding() and _velocity.y > 0.0:
					if _raycast.get_collider().name == "wall" and not is_on_floor():
							_velocity.y += wall_slide_gravity * delta
							_velocity.y = min(_velocity.y, wall_slide_speed)
					else:
						_wall_slide = false
			if Input.is_action_pressed("left"):
				_velocity.x = lerp(_velocity.x, -speed, 0.1) 
				_sprite.flip_h = true
			elif Input.is_action_pressed("right"):
				_velocity.x = lerp(_velocity.x, speed, 0.1)
				_sprite.flip_h = false
			move_and_fall()
		States.CLIMB:
			if is_falling and not on_climbable_wall():
				state = States.FALLING
				continue
			if is_on_floor():
				state = States.FLOOR
				continue
			if not on_climbable_wall() and on_the_wall():
				state =  States.WALL
				continue
			# This is for climbable walls only
			if _raycast.is_colliding():
				if _raycast.get_collider().name == "climbableWall":
					if Input.is_action_pressed("down"):
						_velocity.y = _vertical_direction * wall_climb_speed
					elif Input.is_action_pressed("up"):
						_velocity.y = -(_vertical_direction * wall_climb_speed)
					player_mov()
			move_and_fall()
					#move_and_climb()

	# Flip collsions and raycasts when facing left or right
	if not is_zero_approx(_velocity.x):
		_pivot.scale.x = sign(_velocity.x) * _start_scale.x

# Controls player movement and sprite direction
func player_mov():
	if Input.is_action_pressed("left"):
		_velocity.x = lerp(_velocity.x, -speed, 0.1) 
		_sprite.flip_h = true
	elif Input.is_action_pressed("right"):
		_velocity.x = lerp(_velocity.x, speed, 0.1)
		_sprite.flip_h = false
	else:
		_velocity.x = lerp(_velocity.x, 0, 0.5)

# Gravity of the player over time
func move_and_fall():
	_velocity.y += gravity
	_velocity = move_and_slide(_velocity, UP_DIRECTION)

# Gravity of player when on a climbable wall
func move_and_climb():
	_velocity.y += wall_climb_gravity
	_velocity = move_and_slide(_velocity, UP_DIRECTION)

# When player picks up rocketboots, increase max_jumps += 1
func _on_Double_Jump_Pickup():
	_has_double_jump_item = true
	max_jumps += 1

# When player reaches this zone, decrease max_jumps -= 1
func _on_loseDoubleJump():
	_has_double_jump_item = false
	max_jumps -= 1

func _onGlovePickup():
	_has_climbing_item = true
	print("You can now climb certain walls!")

func _on_passedSlowZone():
	print("Wow! You're old now!")
	#var current_speed = speed
	if speed >= 0:
		speed -= SLOW_SPEED # <--- Example to see if it works

func on_the_wall():
	if _raycast.is_colliding():
		if _raycast.get_collider().name == "wall": #or _raycast.get_collider().name == "climbableWall" and not is_on_floor():
			return true
	else:
		return false

func on_climbable_wall():
	if _raycast.is_colliding():
		if _raycast.get_collider().name == "climbableWall" and not is_on_floor():
			return true
	else:
		return false

func is_on_ledge() -> bool:
	var is_on_ledge = false
	var is_on_ledge_hori = false

	if _ledgeRay.is_colliding():
		var collision = _ledgeRay.get_collider()
		var relative_position = _ledgeRay.get_collision_point() - collision.position
		is_on_ledge = relative_position.y < 0

	if _ledgeRayHori.is_colliding():
		is_on_ledge_hori = true

	return is_on_ledge && is_on_ledge_hori
