extends CharacterBody2D
class_name SmartPet

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -600.0
@export var totalWallJumps := 1
@export var totalAirJumps := 1

const FILE_PATH := "user://actions.json"

var actions = []
var index = 1

var complete = false
var endBody = false

func _ready() -> void:
	load_actions()
	SPEED = actions[0][0]
	JUMP_VELOCITY = actions[0][1]
	totalAirJumps = actions[0][2]
	totalWallJumps = actions[0][3]

func _physics_process(_delta: float) -> void:
	if index >= actions.size(): return
	if "EOF" in actions[index] and not complete:
		complete = true
		var target_pos = Vector2(actions[index][0], actions[index][1])
		if global_position.distance_to(target_pos) < 2.0 or endBody:
			get_parent().add_dude() if get_parent().name != "Dudes" else get_parent().get_parent().add_dude()
			print("Well done!")
		else:
			print("FAILED.")
			global_position = get_parent().get_parent().find_child("Start").get_child(0).global_position
			complete = false
			index = 1
		return
	var frame = actions[index]
	if frame.size() >= 2:
		velocity.x = float(frame[0])
		velocity.y = float(frame[1])
	move_and_slide()
	if not complete: index += 1

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
