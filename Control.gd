extends Control

@onready var right: TextureButton = $Right
@onready var left: TextureButton = $Left

func _on_right_pressed() -> void:
	get_tree().change_scene_to_file("res://stop_watch.tscn")


func _on_left_pressed() -> void:
	get_tree().change_scene_to_file("res://m_timer.tscn")
