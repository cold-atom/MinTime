extends Control

@onready var left: TextureButton = $Left

func _on_left_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
