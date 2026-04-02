extends Control

func _ready() -> void:
	$Panel/Sprite2D.texture.noise.seed = randi_range(0, 100)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level.tscn")
