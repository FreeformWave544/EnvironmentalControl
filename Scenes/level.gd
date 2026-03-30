extends Node2D

func add_dude():
	var dude = preload("res://Scenes/Entities/player.tscn").instantiate()
	$Dudes.add_child(dude)

func _on_start_body_entered(body: Node2D) -> void:
	if body is Player:
		body.recording = false
		get_parent().add_dude()
