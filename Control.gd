extends Control

@onready var right: TextureButton = $Right
@onready var left: TextureButton = $Left

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Right"):
		get_tree().change_scene_to_file("res://stop_watch.tscn")
	
	if event.is_action_pressed("Left"):
		get_tree().change_scene_to_file("res://m_timer.tscn")

func _on_right_pressed() -> void:
	get_tree().change_scene_to_file("res://stop_watch.tscn")

func _on_left_pressed() -> void:
	get_tree().change_scene_to_file("res://m_timer.tscn")
