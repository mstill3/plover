extends KinematicBody2D
class_name Crocman


const FLOOR_NORMAL := Vector2.UP

export var speed := Vector2(70, 200)
export var gravity := 500.0

var _velocity := Vector2.ZERO


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
#	print(_velocity.x)
#	print(_velocity)
	if _velocity.x == 0:
		_velocity.x = - _velocity.x
		speed.x = -speed.x
		$AnimatedSprite.flip_h = speed.x > 0
	_velocity.x += delta*speed.x
	_velocity.y += gravity * delta
	_velocity.x = clamp(_velocity.x, -40, 40)
	_velocity = move_and_slide(_velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_PlayerSight_body_entered(player: Player) -> void:
#	print("see")
	var left = player.position.x < position.x
	
	print(left)
