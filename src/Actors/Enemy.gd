extends Actor
class_name Enemy, "res://assets/enemy.png"

export var score := 100

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x


func _on_StompDetector_body_entered(body: Node) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	die()
	

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	var snap := Vector2.DOWN * 65.0
	_velocity.y = move_and_slide_with_snap(
		_velocity, snap, FLOOR_NORMAL, true, 4, PI/3.0
	).y


func die() -> void:
	get_node("CollisionShape2D").disabled = true
	queue_free()
	PlayerData.score += score
