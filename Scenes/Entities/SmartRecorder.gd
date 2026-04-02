extends CharacterBody2D
class_name SmartPlayer

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -600.0
@export var totalAirJumps := 1
@export var totalWallJumps := 1
var wallJumped := 0
var airJumped := 0
const FILE_PATH := "user://actions.json"
var actions: Array = [[SPEED, JUMP_VELOCITY, totalAirJumps, totalWallJumps]]
var index: int = 0

var recording := false:
	set(v):
		recording = v
		if v:
			$Sprite2D.modulate.r += 0.20
			$Sprite2D.modulate.g -= 0.10
			$Sprite2D.modulate.b -= 0.10
		else:
			$Sprite2D.modulate.r -= 0.20
			$Sprite2D.modulate.g += 0.10
			$Sprite2D.modulate.b += 0.10


func _physics_process(delta: float) -> void:
	if not is_on_floor(): velocity += get_gravity() * delta
	else:
		wallJumped = 0
		airJumped = 0
	if Input.is_action_just_pressed("jump"):
		if is_on_floor(): velocity.y = JUMP_VELOCITY
		elif is_on_wall() and wallJumped < totalWallJumps:
			velocity.y = JUMP_VELOCITY
			wallJumped += 1
			airJumped = max(airJumped - 1, 0)
		elif airJumped < totalAirJumps:
			velocity.y = JUMP_VELOCITY
			airJumped += 1
	var direction := Input.get_axis("left", "right")
	if direction != 0: velocity.x = direction * SPEED
	else: velocity.x = move_toward(velocity.x, 0, SPEED)
	if recording: actions.append([velocity.x, velocity.y])
	index += 1
	move_and_slide()
	if recording: save_actions()

func save_actions():
	if not recording: return
	actions[0] = [SPEED, JUMP_VELOCITY, totalAirJumps, totalWallJumps]
	var save_array = actions.duplicate(true)
	save_array.append([global_position.x, global_position.y, "EOF"])
	var f := FileAccess.open(FILE_PATH, FileAccess.ModeFlags.WRITE)
	if f:
		f.store_string(JSON.stringify(save_array))
		f.close()
