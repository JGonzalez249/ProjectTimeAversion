#TODO: make a dedicated wall_jump (X-O) <--- to be replaced possibly by grapple after certain progression
#TODO: make a ledge grab ()  <--- useful for possible future grapple, may need apply to climbable walls
#TODO: limit player vision as they progress ()

#TODO: HUGE REFACTOR FOR PLAYER STATES (in progress)


extends KinematicBody2D
 
enum States {FALLING = 1, DOUBLE_JUMP, FLOOR, WALL, CLIMB} 
var state = States.FALLING
var direction = 1

var UP_DIRECTION := Vector2.UP

var screen_size


export var speed := 450
export var gravity := 35
export var jump_strength := -1000
export var double_jump_strength := -800
export var wall_slide_speed := 75
export var wall_slide_gravity := 1800
export var wall_climb_speed := 50
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


onready var _pivot: Node2D = $Pivot2D
onready var _sprite: AnimatedSprite = $Sprite
onready var _raycast: RayCast2D = $Pivot2D/WallRay/ #<--- To be used for wall climbing and sliding
onready var _ledgeRay: RayCast2D = $Pivot2D/LedgeRay
onready var _ledgeRayHori: RayCast2D = $Pivot2D/LedgeRayHori
onready var _start_scale: Vector2 = _pivot.scale

var is_falling := _velocity.y > 0.0 and not is_on_floor()
func _ready():
	screen_size = get_viewport_rect().size # Gets screen size and scales assets

func _physics_process(delta: float) -> void:
	# Variables for conditions
	var is_falling := _velocity.y > 0.0 and not is_on_floor()
	var is_jumping :=  Input.is_action_just_pressed("jump") and is_on_floor()
	
	# Finite State Machine for player conditions
	match state:
		States.FALLING:
			if is_on_floor():
				state = States.FLOOR
				continue
			elif on_the_wall():
				state = States.WALL
				continue
			elif on_climbable_wall() and _has_climbing_item:
				state = States.CLIMB
				continue
			elif is_falling and _has_double_jump_item:
				state = States.DOUBLE_JUMP
				continue
			if is_falling:
				_sprite.play("Falling")
			player_mov()
			set_direction()
			move_and_fall()
		States.DOUBLE_JUMP:
			if is_falling and not _has_double_jump_item:
				state = States.FALLING
				continue
			elif is_on_floor():
				state = States.FLOOR
				continue
			elif on_the_wall():
				state = States.WALL
				continue
			elif on_climbable_wall() and _has_climbing_item:
				state = States.CLIMB
				continue
			if Input.is_action_just_pressed("jump") and _jumps_made < max_jumps:
				_jumps_made += 1
				_sprite.play("JumpStart")
				_velocity.y = double_jump_strength
				state = States.FALLING
			player_mov()
			set_direction()
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
			set_direction()
			move_and_fall()
		States.WALL:
			if is_on_floor():
				state = States.FLOOR
				continue
			elif is_falling and not on_the_wall():
				state = States.FALLING
				continue
			elif on_climbable_wall() and _has_climbing_item:
				state =  States.CLIMB
				continue
			_jumps_made += 1
			on_the_wall()
			player_mov()
			set_direction()
			move_and_fall()
		States.CLIMB:
			if not on_climbable_wall() and on_the_wall():
				state =  States.WALL
				continue
			elif is_falling and not on_climbable_wall():
				state = States.FALLING
				continue
			elif is_on_floor():
				state = States.FLOOR
				continue
			# This is for climbable walls only
			if _has_climbing_item:
				_jumps_made += 1
				on_climbable_wall()
			player_mov()
			set_direction()
			move_and_fall()
	
	# Flips the raycasts of the player depending on direction
#	if not is_zero_approx(_velocity.x):
#		_pivot.scale.x = sign(_velocity.x) * _start_scale.x

func set_direction():
	direction = 1 if not _sprite.flip_h else -1
	_raycast.rotation_degrees = 90 * -direction
	_ledgeRay.position.x = 15 * -direction
	_ledgeRayHori.rotation_degrees = 90 * -direction


func wall_jump():
	if Input.is_action_just_released("jump") and (Input.is_action_pressed("left") and direction == 1):
		_velocity.x = wall_jump_strength * direction
		_velocity.y = jump_strength * 0.9
	elif Input.is_action_just_pressed("jump") and (Input.is_action_pressed("right") and direction == -1):
		_velocity.x = wall_jump_strength * -direction
		_velocity.y = jump_strength * 0.9

# Controls player movement and sprite direction on x-axis
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
	if on_climbable_wall():
		_velocity.y += wall_climb_gravity
	else:
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

func _on_passedSlowZone():
	#var current_speed = speed
	if speed >= 0:
		speed -= SLOW_SPEED # <--- Example to see if it works

func on_the_wall():
	if _raycast.is_colliding() and _velocity.y > 0.0:
		# Player will wallside whether or not they _has_climbing_item
		if _raycast.get_collider().name == "wall" or (_raycast.get_collider().name == "climbableWall") and not is_on_floor():
			_velocity.y = wall_slide_gravity
			_velocity.y = min(_velocity.y, wall_slide_speed)
			return true
	else:
		_wall_slide = false
		return false

func on_climbable_wall():
	if _has_climbing_item:
		if _raycast.is_colliding():
			if _raycast.get_collider().name == "climbableWall" and not is_on_floor():
				move_and_climb()
				_wall_slide = false
				if Input.is_action_pressed("down") and not is_falling:
					_velocity.y = wall_climb_speed
				elif Input.is_action_pressed("up") and not is_falling:
					_velocity.y = -(wall_climb_speed)
				else:
					_velocity.y = wall_climb_gravity
				return true
	elif not _has_climbing_item:
		on_the_wall()
	return false
