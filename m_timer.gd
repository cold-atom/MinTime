extends Control

@onready var countdown: Label = $CountDown
@onready var sbox_seconds: SpinBox = $VBoxContainer/GridContainer/Seconds
@onready var sbox_minutes: SpinBox = $VBoxContainer/GridContainer/Minutes
@onready var sbox_hours: SpinBox = $VBoxContainer/GridContainer/Hours
@onready var timer: Timer = $Timer

var seconds = 0
var wait_time = 1
var timer_state = false
var accumulated_time = 0.0

func _ready():
	sbox_hours.connect("value_changed", Callable(self, "_on_time_value_changed"))
	sbox_minutes.connect("value_changed", Callable(self, "_on_time_value_changed"))
	sbox_seconds.connect("value_changed", Callable(self, "_on_time_value_changed"))
	timer.start()

func _process(delta):
	if timer_state:
		if seconds > 0:
			accumulated_time += delta
			if accumulated_time >= 1.0:
				seconds -= 1
				accumulated_time = 0.0
				
			if seconds <= 0:
				seconds = 0
				timer_state = false
			
			update_timer_display()
		else:
			timer_state = false

func _on_start_pressed():
	# Calculate the total seconds from the spin boxes
	seconds = sbox_hours.value * 3600 + sbox_minutes.value * 60 + sbox_seconds.value
	timer_state = true
	accumulated_time = 0.0
	update_timer_display()

func _on_stop_pressed():
	timer_state = false

func _on_reset_pressed():
	timer_state = false
	seconds = 0
	accumulated_time = 0.0

	sbox_hours.value = 0
	sbox_minutes.value = 0
	sbox_seconds.value = 0
	
	countdown.text = "00:00:00"

func _on_time_value_changed(_value):
	# This function is kept for any future use but is not required here
	pass

func update_timer_display():
	var hours = fmod(fmod(seconds, 3600 * 24) / 3600, 24)
	var mins = fmod(seconds, 60 * 60) / 60
	var sec = fmod(seconds, 60)
	
	var formatted_time = "%02d:%02d:%02d" % [hours, mins, sec]
	countdown.text = formatted_time
