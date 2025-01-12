extends Control

@onready var timah: Label = $VBoxContainer/Timah

var time = 0
var timer_on = false


func _process(delta):
	if timer_on:
		time += delta
		
		var sec = fmod(time, 60)
		var mins = fmod(time, 60*60)/60
		var hours = fmod(fmod(time,3600*24) / 3600,24)
		
		var time_passed = "%02d:%02d:%02d" % [hours,mins,sec]
		timah.text = time_passed

func _unhandled_input(event):
	if event.is_action_pressed("Stop Watch"):
		timer_on = !timer_on

func _on_start_pressed():
	timer_on = true

func _on_stop_pressed():
	timer_on = false

func _on_reset_pressed() -> void:
	time = 0
	timah.text = "00:00:00"
