extends Control

onready var statistics: Label = get_node("Statistics")

func _ready() -> void:
	statistics.text = "Score: %s\nDeaths: %s" % [PlayerData.score, PlayerData.deaths]
