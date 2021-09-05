extends CanvasLayer


func _ready() -> void:
	$ColorRect.visible = true


func _on_Boulder_touch_player() -> void:
#	PlayerData.deaths += 1
	print("restart")
