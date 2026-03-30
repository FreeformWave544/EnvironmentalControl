extends CharacterBody2D
class_name Pet

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -800.0
const FILE_PATH := "res://recordings/actions.json"

var actions = []
var index = 1

func _ready() -> void:
	load_actions()
	SPEED = actions[0][0]
	JUMP_VELOCITY = actions[0][1]

var complete = false
func _physics_process(delta: float) -> void:
	if "EOF" in actions[index] and not complete:
		complete = true
		if abs(global_position - Vector2(actions[index][0], actions[index][1])) < Vector2(0.1, 0.1):
			get_parent().add_dude() if get_parent().name != "Dudes" else get_parent().get_parent().add_dude()
			print("Well done!")
		else:
			print("FAILED.")
			global_position = get_parent().get_parent().find_child("Start").global_position
			complete = false ; index = 1
		return
	if not is_on_floor(): velocity += get_gravity() * delta
	if "jump" in actions[index] and is_on_floor(): velocity.y = JUMP_VELOCITY
	var direction := 0
	for act in actions[index]:
		if str(act) != "jump": direction = float(act)
	if direction: velocity.x = float(direction) * SPEED
	else: velocity.x = move_toward(velocity.x, 0, SPEED)
	if not complete: index += 1
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
