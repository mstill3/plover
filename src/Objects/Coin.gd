extends Area2D
class_name Coin, "res://assets/images/coin_face.png"


onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

export var score := 1


func _on_body_entered(body: Node) -> void:
	picked()


func picked() -> void:
	anim_player.play("fade_out")
	PlayerData.score += score
