extends Node2D

var back := false
func _physics_process(delta: float) -> void:
	var targetObject = $ShopPortal/GPUParticles2D.process_material.emission_shape_scale.y
	if targetObject > 0.9 and not back:
		targetObject = lerp(targetObject, 0.8, 0.01)
	else:
		back = true
		targetObject = lerp(targetObject, 1.5, 0.005)
		if targetObject > 1.4: back = false
	$ShopPortal/GPUParticles2D.process_material.emission_shape_scale.y = targetObject

func _ready() -> void:
	if Global.smart: smartify()

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
	smarted = true
	$Recorder.queue_free()
	call_deferred("add_child", preload("res://Scenes/Entities/SmartRecorder.tscn").instantiate())
	dudeDir = "res://Scenes/Entities/SmartPlayer.tscn"

func _on_shop_portal_body_entered(_body: Node2D) -> void:
	add_child(load("res://Scenes/shop.tscn").instantiate())

var smarted := false
func _update_stats():
	var recorder = $Recorder if Global.smart else $SmartRecorder
	recorder.SPEED = 300.0 * Global.playerSpeedMulti
	if Global.smart and not smarted: smartify()
