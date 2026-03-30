extends Node2D

func add_dude():
	var dude = preload("res://Scenes/Entities/player.tscn").instantiate()
	$Dudes.call_deferred("add_child", dude)
	dude.global_position = $Start.global_position

func _on_start_body_entered(body: Node2D) -> void:
	if body is Player:
		body.recording = true


func _on_end_body_entered(body: Node2D) -> void:
	if body is Player:
		body.recording = false
		add_dude()
	elif body is Pet:
		body.global_position = $Start.global_position
		if not randi_range(1,5) == 1: return
		await get_tree().create_timer(0.1).timeout
		add_dude()


func _on_deathzone_body_entered(body: Node2D) -> void:
	if body is Player:
		body.global_position = global_position
	elif body is Pet:
		body.global_position = $Start.global_position
