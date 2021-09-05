tool
extends Control

onready var scene_tree := get_tree()
onready var pause_overlay: ColorRect = get_node("PauseOverlay")
onready var score: Label = get_node("Coins/ScoreLabel")
onready var paused_label: Label = get_node("PauseOverlay/Title")

var paused := false setget set_paused


func _ready() -> void:
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_PlayerData_player_died")
	update_interface()


func _PlayerData_player_died() -> void:
	self.paused = true
	paused_label.text = "You died"


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not paused_label.text == "You died":
#		add self so it explicitly calls the set_paused method since its in the same script
		self.paused = not paused
#		stop caring about the pause button press after this mehtod
		scene_tree.set_input_as_handled()


func update_interface() -> void:
	score.text = "%s" % PlayerData.score 


func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
	
