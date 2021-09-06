extends Actor
class_name Player, "res://assets/images/player_face.png"

onready var anim_sprite := $AnimatedSprite

var facing_left := false
var attacking := false
var rolling := false
var dying := false
var set_speed: Vector2
export var MAX_JUMPS := 2
var num_jumps := MAX_JUMPS

var initial_collsion_layer


func _ready() -> void:
	assert(Events.connect("hurt_player", self, "_hurt_player") == 0, "Could not connect signal to fn")
	anim_sprite.animation = "idle"
	set_speed = speed
	initial_collsion_layer = collision_layer


# parents physics_process called before
func _physics_process(delta: float) -> void:
	move()
	animate()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart"):
		PlayerData.score = 0
		get_tree().paused = false
		get_tree().reload_current_scene()
	
	if not attacking and not rolling:
		attacking = Input.is_action_just_pressed("attack") and is_on_floor()
		rolling = Input.is_action_just_pressed("roll") and is_on_floor()
		if rolling:
			speed = set_speed
			speed.x += 30
#			$CollisionShape2D.disabled = true
			collision_layer = 0



func move() -> void:
	var direction := get_direction()
		
	if is_on_floor():
		num_jumps = MAX_JUMPS
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		num_jumps -= 1
	
	#	multi jump
	if Input.is_action_just_pressed("jump") and not is_on_floor() and num_jumps < MAX_JUMPS and num_jumps > 0:
#		print("multi jump")
		direction.y = -1
		num_jumps -= 1
	
	if rolling and direction.x == 0:
		if facing_left:
			direction.x = -1
		else:
			direction.x = 1
		
	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var snap := Vector2.DOWN * 50.0 if direction.y == 0.0 else Vector2.ZERO
#	if rolling or attacking:
#		_velocity.y = -1
	if attacking:
		_velocity = Vector2.ZERO
	if dying:
		_velocity.x = 0
		if _velocity.y < 0:
			_velocity.y = 0
	
	_velocity.y = move_and_slide_with_snap(
		_velocity, snap, FLOOR_NORMAL, true, 4, PI/3.0
	).y
	if _velocity.x != 0:
		facing_left = _velocity.x < 0
		
	if not rolling:
		speed = set_speed
#		$CollisionShape2D.disabled = false
		collision_layer = initial_collsion_layer
	

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)


# pure fn -> doesnt modify vars just takes in vars and returns new var
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out := linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out


func calculate_stomp_velocity(
		linear_velocity: Vector2,
		impulse: float
	) -> Vector2:
	var out := linear_velocity
	out.y = -impulse
	return out


func die() -> void:
	PlayerData.deaths += 1
	queue_free()


func animate() -> void:
#	death
	if dying:
		anim_sprite.animation = "death"
	elif attacking:
		anim_sprite.animation = "attack"
	elif rolling:
		anim_sprite.animation = "roll"
	elif _velocity.y != 0:
		anim_sprite.animation = "jump"
	elif _velocity.x != 0:
		anim_sprite.animation = "run"
	else:
		anim_sprite.animation = "idle"
	anim_sprite.flip_h = facing_left


func _on_AnimatedSprite_animation_finished() -> void:
	if dying:
		PlayerData.deaths += 1
		dying = false
	elif attacking:
		attacking = false
	elif rolling:
		rolling = false


func _hurt_player(damage: int) -> void:
	print("hhihii")
	dying = true
