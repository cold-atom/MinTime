extends Control

@onready var countdown: Label = $CountDown
@onready var sbox_seconds: SpinBox = $VBoxContainer/GridContainer/Seconds
@onready var sbox_minutes: SpinBox = $VBoxContainer/GridContainer/Minutes
@onready var sbox_hours: SpinBox = $VBoxContainer/GridContainer/Hours

var seconds = 0

var timer_state = false

func _ready():
	sbox_hours.connect("value_changed", Callable(self, "_on_time_value_changed"))
	sbox_minutes.connect("value_changed",Callable(self, "_on_time_value_changed"))
	sbox_seconds.connect("value_changed",Callable(self, "_on_time_value_changed"))

func _process(delta):
	if timer_state:
		if seconds > 0:
			seconds -= delta
			if seconds <= 0:
				seconds = 0
				timer_state = false
			
			var hours = fmod(fmod(seconds,3600*24) / 3600,24)
			var mins = fmod(seconds, 60*60)/60
			var sec = fmod(seconds, 60)
			
			var formatted_time = "%02d:%02d:%02d" % [hours,mins,sec]
			
			countdown.text =formatted_time

		else:
			timer_state = false


func _on_start_pressed():
	timer_state = true

func _on_time_value_changed(value):
	seconds = sbox_hours.value * 3600 + sbox_minutes.value * 60 + sbox_seconds.value

func _on_stop_pressed():
	timer_state = false

func _on_reset_pressed():
	timer_state = false
	seconds = 0
	
	# Resets the spinbox to 0
	sbox_hours.value = 0
	sbox_minutes.value = 0
	sbox_seconds.value = 0
	
	countdown.text = "00:00:00"
