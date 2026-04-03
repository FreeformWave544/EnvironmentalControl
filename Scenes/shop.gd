extends CanvasLayer

func _ready() -> void:
	$CenterContainer/HBoxContainer/smartify.disabled = Global.smart

func _on_smartify_pressed() -> void:
	Global.smart = true
	$CenterContainer/HBoxContainer/smartify.disabled = true

func _on_speed_pressed() -> void:
	Global.playerSpeedMulti += 0.1

func _on_return_pressed() -> void:
	get_parent()._update_stats()
	call_deferred("queue_free")
