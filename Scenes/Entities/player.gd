extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var actions = []

var index = 0
const FILE_PATH := "res://recordings/actions.json"

func _ready() -> void:
	load_actions()

func _physics_process(delta: float) -> void:
	if "EOF" in actions[index]:
		set_process(false)
		print("Finished... ", index)
		return
	if not is_on_floor(): velocity += get_gravity() * delta
	if "jump" in actions[index] and is_on_floor(): velocity.y = JUMP_VELOCITY
	var direction := 0
	for act in actions[index]:
		if str(act) != "jump": direction = float(act)
	if direction: velocity.x = float(direction) * SPEED
	else: velocity.x = move_toward(velocity.x, 0, SPEED)
	index += 1
	move_and_slide()

func load_actions():
	if not FileAccess.file_exists(FILE_PATH):
		print("No actions file found")
		return
	var f := FileAccess.open(FILE_PATH, FileAccess.ModeFlags.READ)
	if not f:
		push_error("Failed to open file for reading")
		return
	var content := f.get_as_text()
	f.close()
	if content == "":
		print("Actions file is empty")
		return
	actions = JSON.parse_string(content)
	if typeof(actions) != TYPE_ARRAY:
		push_error("JSON root is not an array!")
		actions = []
	else: print("Loaded %d frames from JSON" % (actions.size() - 1))
