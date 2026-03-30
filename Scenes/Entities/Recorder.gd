extends CharacterBody2D
class_name Player

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -600.0
const FILE_PATH := "res://recordings/actions.json"

var actions: Array = [[SPEED, JUMP_VELOCITY]]
var index: int = 0

var recording = false
func _physics_process(delta: float) -> void:
	var frame_actions: Array = []
	if not is_on_floor(): velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		frame_actions.append("jump")
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
	else: velocity.x = move_toward(velocity.x, 0, SPEED)
	frame_actions.append(direction)
	actions.append(frame_actions)
	index += 1
	move_and_slide()
	save_actions()

func save_actions():
	if not recording: return
	var save_array = actions.duplicate()
	save_array.append([global_position.x, global_position.y, "EOF"])
	var f := FileAccess.open(FILE_PATH, FileAccess.ModeFlags.WRITE)
	if f:
		f.store_string(JSON.stringify(save_array))
		f.close()
