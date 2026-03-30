extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FILE_PATH := "res://recordings/actions.json"

var actions: Array = []
var index: int = 0

func _physics_process(delta: float) -> void:
	var frame_actions: Array = []
	if not is_on_floor(): velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		frame_actions.append("jump")
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else: velocity.x = move_toward(velocity.x, 0, SPEED)
	frame_actions.append(direction)
	actions.append(frame_actions)
	index += 1
	move_and_slide()
	save_actions()

func _exit_tree() -> void:
	print("Exiting scene, saving actions...")
	actions.append("EOF")
	save_actions()

func save_actions():
	var f := FileAccess.open(FILE_PATH, FileAccess.ModeFlags.WRITE)
	if f:
		f.store_string(JSON.stringify(actions))
		f.close()
