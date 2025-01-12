extends Control

@onready var left: TextureButton = $Left

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Right"):
		get_tree().change_scene_to_file("res://main.tscn")


func _on_left_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
