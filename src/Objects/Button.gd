extends StaticBody2D
class_name Switch, "res://assets/images/button.png"


func _on_Trigger_body_entered(body: Node) -> void:
	$AnimatedSprite.animation = "press"
	$AnimatedSprite.playing = true

func _on_AnimatedSprite_animation_finished() -> void:
	pass
