extends KinematicBody2D
class_name Boulder


const FLOOR_NORMAL := Vector2.UP

export var speed := Vector2(-80, 200)
export var gravity := 500.0
export var damage := 5

var _velocity := Vector2.ZERO


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
#	print (abs(_velocity.x))
	_velocity.x += delta*speed.x
	_velocity.y += gravity * delta
	_velocity.x = clamp(_velocity.x, -50, 50)
	_velocity = move_and_slide(_velocity)
	
	if _velocity.x < -3:
#		print("left")
		$AnimationPlayer.play("rotate_left")
	elif _velocity.x > 3:
		$AnimationPlayer.play("rotate_right")
#		print("right")
	else:
		$AnimationPlayer.stop(false)
#		print("still")


func _on_Area2D_body_entered(body: Node) -> void:
	if abs(_velocity.x) > 5 or abs(_velocity.y) > 0:
		if body is Player:
			Events.emit_signal("hurt_player", damage)
		elif body is Vacuum:
			pass
		else:
			body.queue_free()
