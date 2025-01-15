extends Control

@onready var countdown: Label = $CountDown
@onready var sbox_seconds: SpinBox = $VBoxContainer/GridContainer/Seconds
@onready var sbox_minutes: SpinBox = $VBoxContainer/GridContainer/Minutes
@onready var sbox_hours: SpinBox = $VBoxContainer/GridContainer/Hours
@onready var timer: Timer = $Timer
@onready var time_up_animation: AnimationPlayer = $TimeUpAnimation if has_node("TimeUpAnimation") else null
var total_seconds: int = 0
var remaining_seconds: int = 0
var timer_state: bool = false
var accumulated_time: float = 0.0
var pulse_tween: Tween = null

func _ready():
	sbox_hours.connect("value_changed", Callable(self, "_on_time_value_changed"))
	sbox_minutes.connect("value_changed", Callable(self, "_on_time_value_changed"))
	sbox_seconds.connect("value_changed", Callable(self, "_on_time_value_changed"))
	sbox_hours.min_value = 0
	sbox_hours.max_value = 99
	sbox_minutes.min_value = 0
	sbox_minutes.max_value = 59
	sbox_seconds.min_value = 0
	sbox_seconds.max_value = 59
	
	update_timer_display(0)

func _process(delta: float) -> void:
	if timer_state:
		accumulated_time += delta
		
		if accumulated_time >= 1.0:
			remaining_seconds -= 1
			accumulated_time -= 1.0
			update_timer_display(remaining_seconds)
			
			if remaining_seconds <= 0:
				stop_timer()
				show_time_over()

func _on_start_pressed() -> void:
	if total_seconds > 0:
		stop_animations()
		countdown.modulate = Color.WHITE
		if remaining_seconds <= 0:
			total_seconds = calculate_total_seconds()
			remaining_seconds = total_seconds
		
		timer_state = true
		accumulated_time = 0.0
		update_timer_display(remaining_seconds)

func stop_animations() -> void:
	if time_up_animation:
		time_up_animation.stop()
	if pulse_tween and pulse_tween.is_valid():
		pulse_tween.kill()
		pulse_tween = null

func _on_stop_pressed() -> void:
	stop_timer()

func _on_reset_pressed() -> void:
	stop_timer()
	stop_animations()
	
	total_seconds = 0
	remaining_seconds = 0
	accumulated_time = 0.0
	sbox_hours.value = 0
	sbox_minutes.value = 0
	sbox_seconds.value = 0
	countdown.modulate = Color.WHITE
	update_timer_display(0)

func stop_timer() -> void:
	timer_state = false
	accumulated_time = 0.0

func calculate_total_seconds() -> int:
	return int(sbox_hours.value) * 3600 + int(sbox_minutes.value) * 60 + int(sbox_seconds.value)

func _on_time_value_changed(_value: float) -> void:
	total_seconds = calculate_total_seconds()
	update_timer_display(total_seconds)

func update_timer_display(seconds: int) -> void:
	countdown.text = format_time(seconds)

func format_time(seconds_param: int) -> String:
	var hours := seconds_param / 3600
	var minutes := (seconds_param % 3600) / 60
	var seconds := seconds_param % 60
	
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

func show_time_over() -> void:
	countdown.text = "Time Up"
	if time_up_animation:
		time_up_animation.play("pulse")
	else:
		create_pulse_effect()

func create_pulse_effect() -> void:
	if pulse_tween and pulse_tween.is_valid():
		pulse_tween.kill()
	
	pulse_tween = create_tween()
	pulse_tween.set_loops(0)
	pulse_tween.tween_property(countdown, "modulate", Color(1, 0, 0, 0.5), 0.5)
	pulse_tween.tween_property(countdown, "modulate", Color.WHITE, 0.5)

# -
