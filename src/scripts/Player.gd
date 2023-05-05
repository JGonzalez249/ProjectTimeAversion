#TODO: limit player vision as they progress (in progess)
	#Make a state machine for blur shaders

#TODO: HUGE REFACTOR TOWARDS PLAYER STATES (in progress)


extends CharacterBody2D
 
enum States {FALLING = 1, DOUBLE_JUMP, FLOOR, WALL, CLIMB, LEDGE_GRAB}
var state = States.FALLING
var direction = 1

var UP_DIRECTION := Vector2.UP

var screen_size


#const SLOW_SPEED := 75
const LEDGE_CLIMB_SPEED := 75


var _velocity := Vector2.ZERO

var dialogue1 = preload("res://src/dialogue/Level01.dialogue")
var dialogue2 = preload("res://src/dialogue/Level02.dialogue")
var dialogue3 = preload("res://src/dialogue/Level03.dialogue")

@onready var _sprite: AnimatedSprite2D = $Sprite2D
@onready var _anim_play: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var _raycast: RayCast2D = $Pivot2D/WallRay
@onready var _ledgeRay: RayCast2D = $Pivot2D/LedgeRay
@onready var _ledgeRayHori: RayCast2D = $Pivot2D/LedgeRayHori
@onready var _sfxPlayer = $Overlapping_SFXPlayer
@onready var _blur1: ColorRect = $BlurStates/Blur01
@onready var _blur2: ColorRect = $BlurStates/Blur02
@onready var _blur3: ColorRect = $BlurStates/Blur03

func _ready():
	screen_size = get_viewport_rect().size # Gets screen size and scales assets
func _physics_process(_delta: float) -> void:
	print(state)
	# Variables for conditions in real time
	var is_jumping :=  Input.is_action_just_pressed("jump") and is_on_floor()
	var is_falling := _velocity.y > 0.0 and not is_on_floor()
	
	# Finite State Machine for player conditions
	match state:
		States.FALLING:
			if is_on_floor():
				_sfxPlayer.play_audio("res://src/assets/audio/sfx/jumpLanding.wav")
				state = States.FLOOR
				
			elif on_the_wall():
				state = States.WALL
				
			elif on_climbable_wall() and PlayerVariables._has_climbing_item:
				state = States.CLIMB
				
			elif is_falling and PlayerVariables._has_double_jump_item:
				state = States.DOUBLE_JUMP
				
			if is_falling:
				_anim_play.play("falling")
			player_mov()
			set_direction()
			move_and_fall(false)
		States.DOUBLE_JUMP:
			if is_falling and not PlayerVariables._has_double_jump_item:
				state = States.FALLING
				
			elif is_on_floor():
				_sfxPlayer.play_audio("res://src/assets/audio/sfx/jumpLanding.wav")
				state = States.FLOOR
				
			elif on_the_wall():
				state = States.WALL
				
			elif on_climbable_wall() and PlayerVariables._has_climbing_item:
				state = States.CLIMB
				
			if Input.is_action_just_pressed("jump") and PlayerVariables._jumps_made < PlayerVariables.max_jumps:
				PlayerVariables._jumps_made += 1
				_anim_play.play("jump")
				_sfxPlayer.play_audio("res://src/assets/audio/sfx/doubleJump.wav")
				_velocity.y = PlayerVariables.double_jump_strength
				state = States.FALLING
			elif is_falling:
				_anim_play.play("falling")
			player_mov()
			set_direction()
			move_and_fall(false)
		States.FLOOR:
			PlayerVariables._jumps_made = 0
			if not is_on_floor():
				state = States.FALLING
				
			if Input.is_action_pressed("left"):
				if PlayerVariables.blurStrength == 3:
					_anim_play.play("crouchWalk")
				else:
					_anim_play.play("run")
				_velocity.x = lerp(_velocity.x, -PlayerVariables.speed, 0.1) 
				_sprite.flip_h = true
			elif Input.is_action_pressed("right"):
				if PlayerVariables.blurStrength == 3:
					_anim_play.play("crouchWalk")
				else:
					_anim_play.play("run")
				_velocity.x = lerp(_velocity.x, PlayerVariables.speed, 0.1)
				_sprite.flip_h = false
			else:
				if PlayerVariables.blurStrength == 3:
					_anim_play.play("crouchIdle")
				else:
					_anim_play.play("idle")
				_velocity.x = lerp(_velocity.x, 0, 0.9)
			if is_jumping:
				_anim_play.play("jump")
				_velocity.y = PlayerVariables.jump_strength
				PlayerVariables._jumps_made += 1
				state = States.FALLING
			set_direction()
			move_and_fall(false)
		States.WALL:
			if is_on_floor():
				state = States.FLOOR
				
			elif is_falling and not on_the_wall():
				state = States.FALLING
				
			elif ledge_grab():
				state = States.LEDGE_GRAB
				
			elif on_climbable_wall() and PlayerVariables._has_climbing_item:
				state =  States.CLIMB
				
			if Input.is_action_just_pressed("jump") and ((Input.is_action_pressed("left") and direction == -1) or (Input.is_action_pressed("right") and direction == 1)):
				_anim_play.play("jump")
				_velocity.x = PlayerVariables.wall_pushback * -direction
				_velocity.y = PlayerVariables.wall_jump_strength
				state = States.FALLING
			elif Input.is_action_just_pressed("jump"):
				_anim_play.play("jump")
				_velocity.x = PlayerVariables.wall_pushback
				state = States.FALLING
			player_mov()
			set_direction()
			move_and_fall(false)
		States.CLIMB:
			if not on_climbable_wall() and on_the_wall():
				state =  States.WALL
				
			elif is_falling and not on_climbable_wall():
				state = States.FALLING
				
			elif is_on_floor():
				state = States.FLOOR
				
			elif ledge_grab():
				state = States.LEDGE_GRAB
				
			if Input.is_action_just_pressed("jump") and ((Input.is_action_pressed("left") and direction == -1) or (Input.is_action_pressed("right") and direction == 1)):
				_anim_play.play("jump")
				_velocity.x = PlayerVariables.wall_pushback * -direction
				_velocity.y = PlayerVariables.wall_jump_strength
				state = States.FALLING
			elif (Input.is_action_just_pressed("jump")) or (Input.is_action_just_pressed("jump") and Input.is_action_pressed("up")):
				_anim_play.play("jump")
				_velocity.x = PlayerVariables.wall_pushback
				state = States.FALLING
			player_mov()
			set_direction()
			move_and_fall(true)
		States.LEDGE_GRAB:
			if is_falling:
				state = States.FALLING
				
			if Input.is_action_just_pressed("jump") and ((Input.is_action_pressed("left") and direction == -1) or (Input.is_action_pressed("right") and direction == 1)):
				_anim_play.play("jump")
				_velocity.x = PlayerVariables.wall_pushback * -direction
				_velocity.y = PlayerVariables.wall_jump_strength
				state = States.FALLING
			elif Input.is_action_pressed("up") and not is_on_floor():
				ledge_climb()
				state = States.FLOOR
			player_mov()
			set_direction()
			move_and_fall(false)
	blur_state()
	
func set_direction():
	direction = 1 if not _sprite.flip_h else -1
	_raycast.rotation_degrees = 90 * -direction
	_ledgeRay.position.x = -25 * -direction
	_ledgeRayHori.rotation_degrees = 90 * -direction

# Controls player movement and sprite direction on x-axis
func player_mov():
	if Input.is_action_pressed("left"):
		_velocity.x = lerp(_velocity.x, -PlayerVariables.speed, 0.1) 
		_sprite.flip_h = true
	elif Input.is_action_pressed("right"):
		_velocity.x = lerp(_velocity.x, PlayerVariables.speed, 0.1)
		_sprite.flip_h = false
	else:
		_velocity.x = lerp(_velocity.x, 0, 0.5)

# Gravity of the player over time
func move_and_fall(_has_climbable_item: bool):
	if on_climbable_wall():
		_velocity.y += PlayerVariables.wall_climb_gravity
		set_velocity(_velocity)
		set_up_direction(UP_DIRECTION)
		move_and_slide()
		_velocity =  velocity
	else:
		_velocity.y += PlayerVariables.gravity
		set_velocity(_velocity)
		set_up_direction(UP_DIRECTION)
		move_and_slide()
		_velocity = velocity


func _onDoubleJumpPickup():
	_sfxPlayer.play_audio("res://src/assets/audio/sfx/pickUpFX.wav")
	PlayerVariables._has_double_jump_item = true
	PlayerVariables.max_jumps += 1
	DialogueManager.show_example_dialogue_balloon(dialogue1, "picked_up_DoubleJump")

# When player reaches this zone, decrease max_jumps -= 1
func _on_loseDoubleJump():
	PlayerVariables._has_double_jump_item = false
	PlayerVariables.max_jumps -= 1
	DialogueManager.show_example_dialogue_balloon(dialogue3, "loseDoubleJump")

func _onGlovePickup():
	_sfxPlayer.play_audio("res://src/assets/audio/sfx/pickUpFX.wav")
	PlayerVariables._has_climbing_item = true
	DialogueManager.show_example_dialogue_balloon(dialogue1, "picked_up_Gloves")
	
func _on_loseGloves():
	PlayerVariables._has_climbing_item = false
	

func _on_passedSlowZone():
	if PlayerVariables.speed >= 0:
		PlayerVariables.speed -= PlayerVariables.LOWER_SPEED

func on_the_wall():
	if _raycast.is_colliding():
		# Player will wallside whether or not they _has_climbing_item
		if (_raycast.get_collider().name == "wall" or (_raycast.get_collider().name == "climbableWall")) and not is_on_floor():
			_anim_play.play("wallSlide")
			_velocity.y = PlayerVariables.wall_slide_gravity
			_velocity.y = min(_velocity.y, PlayerVariables.wall_slide_speed)
			return true
	else:
		PlayerVariables._wall_slide = false
		return false

# TODO: Might need to fix this but it works so far.
func on_climbable_wall():
	if _raycast.is_colliding():
		if _raycast.get_collider().name == "climbableWall" and not is_on_floor():
			if PlayerVariables._has_climbing_item:
				if Input.is_action_pressed("down"):
					_velocity.y = PlayerVariables.wall_climb_speed
					_anim_play.play_backwards("wallClimb")
				elif Input.is_action_pressed("up"):
					_velocity.y = -(PlayerVariables.wall_climb_speed)
					_anim_play.play("wallClimb")
				elif Input.is_action_just_pressed("jump"):
					_velocity.y = PlayerVariables.wall_jump_strength
				else:
					_velocity.y = PlayerVariables.wall_climb_gravity
					_anim_play.play("wallLand")
			elif States.CLIMB\
			and Input.is_action_just_pressed("jump"):
				_velocity.y = PlayerVariables.wall_jump_strength
		return true
	elif not PlayerVariables._has_climbing_item:
		on_the_wall()
	return false


func ledge_grab():
	if _ledgeRay.is_colliding() and not _ledgeRayHori.is_colliding():
		if not _ledgeRay.get_collider().name == "floor":
			_anim_play.play("ledgeGrab")
			_velocity = Vector2.ZERO
			position.y = _ledgeRay.get_collision_point().y - _ledgeRayHori.position.y
			state = States.LEDGE_GRAB
			return true
	return false

func ledge_climb():
	_velocity = Vector2.ZERO
	position.y -= LEDGE_CLIMB_SPEED * get_process_delta_time()
	if position.y < _ledgeRay.get_collision_point().y - _ledgeRayHori.position.y:
		_anim_play.play("ledgeClimb")
		position = _ledgeRay.get_collision_point()
		await get_node("Sprite2D/AnimationPlayer").animation_finished
		state = States.FLOOR


func blur_state():
	if PlayerVariables.blurStrength == 1:
		_blur1.visible = true
	elif PlayerVariables.blurStrength == 2:
		_blur1.visible = false
		_blur2.visible = true
	elif PlayerVariables.blurStrength == 3:
		_blur2.visible = false
		_blur3.visible =  true
	else:
		return

func _on_Actionable_on_ai_talks():
	if GameStates.level == 1:
		DialogueManager.show_example_dialogue_balloon(dialogue1, "AI_Talk")
	if GameStates.level == 2:
		DialogueManager.show_example_dialogue_balloon(dialogue2, "AI_Talk")
	if GameStates.level == 3:
		DialogueManager.show_example_dialogue_balloon(dialogue3, "AI_Talk")

func play_death_anim():
	if GameStates.die:
		_anim_play.play("death")
		await get_node("Sprite2D/AnimationPlayer").animation_finished

