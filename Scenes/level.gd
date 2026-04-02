extends Node2D


var dudeDir := "res://Scenes/Entities/player.tscn"
func add_dude():
	var dude = load(dudeDir).instantiate()
	$Dudes.call_deferred("add_child", dude)
	dude.global_position = $Start/CollisionShape2D.global_position

func _on_start_body_entered(body: Node2D) -> void:
	if (body is Player or body is SmartPlayer):
		body.recording = true
		print("Starting...")

func _on_end_body_entered(body: Node2D) -> void:
	print("End entered...")
	if (body is Player or body is SmartPlayer) and body.recording:
		print("Finished")
		body.recording = false
		add_dude()
		body.global_position = global_position
		if body is not SmartPlayer: smartify()
	elif body is Pet:
		body.endBody = true
		body.global_position = $Start/CollisionShape2D.global_position
		if not randi_range(1,5) == 1: return
		await get_tree().create_timer(0.1).timeout
		add_dude()

func _on_deathzone_body_entered(body: Node2D) -> void:
	if (body is Player or body is SmartPlayer):
		body.recording = false
		body.global_position = $Start/CollisionShape2D.global_position
	elif body is Pet:
		body.global_position = $Start/CollisionShape2D.global_position


func smartify():
	$Recorder.queue_free()
	add_child(preload("res://Scenes/Entities/SmartRecorder.tscn").instantiate())
	dudeDir = "res://Scenes/Entities/SmartPlayer.tscn"
