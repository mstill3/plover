tool
extends StaticBody2D
class_name Portal, "res://assets/images/teleport_pad.png"


export var next_scene: PackedScene

onready var anim_player: AnimationPlayer = $AnimationPlayer


func _on_Trigger_body_entered(body: Node) -> void:
	$AnimatedSprite.animation = "press"
	$AnimatedSprite.playing = true
	
func _get_configuration_warning() -> String:
	return "The next scene property can't be empty" if not next_scene else ""

func teleport() -> void:
	anim_player.play("fade_in")
#	wait for animation to finsih before contining
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(next_scene)
	





func _on_AnimatedSprite_animation_finished() -> void:
	teleport()
