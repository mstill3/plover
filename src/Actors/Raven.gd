extends Actor
class_name Raven


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	_velocity.x += delta*speed.x
	move_and_slide(_velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
