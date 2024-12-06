extends Control

signal date_update

var opened = false
var date_opened = false

@onready var time_label: Label = $VBoxContainer/Time
@onready var am_pm: Label = $VBoxContainer/AmPM
@onready var date_label: Label = $Date
@onready var settings: Panel = $Settings
@onready var about: Panel = $Settings/About

#Sounds
@onready var click_sound: AudioStreamPlayer = $ClickSound
@onready var toggle_sound: AudioStreamPlayer = $ToggleSound


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	date()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#var current_time = Time.get_time_string_from_system()
	time_calc()
	
func _input(event):
	if event.is_action_pressed("Open Menu"):
		toggle_menu()

func _on_texture_button_pressed():
	toggle_menu()
	click_sound.play()

# toggles the menu based on the flag
func toggle_menu():
	opened = !opened
	if opened:
		settings.visible = true
	else:
		settings.visible = false
	
func time_calc():
	# gets the dictionary of current time from the system
	var current_time = Time.get_time_dict_from_system()
	#var current_time = Time.get_time_string_from_system()
	
	var hours = current_time.hour
	var minutes = current_time.minute
	var seconds = current_time.second
	

	if seconds < 10:
		seconds = "0" + str(seconds)
		
	if minutes < 10:
		minutes = "0" + str(minutes)
	
	# converts the time to 12 hour format by substracting the current hour (24 hour format)
	# to 12
	#print(seconds)
	if hours == 0:
		hours = 12
		time_label.text = str(hours) + ":" + str(minutes) + ":" + str(seconds)
		am_pm.text = "AM"
		date_update.emit()

	elif hours < 12:
		time_label.text = str(hours) + ":" + str(minutes) + ":" + str(seconds)
		am_pm.text = "AM"
	elif hours == 12:
		time_label.text = str(hours) + ":" + str(minutes) + ":" + str(seconds)
		am_pm.text = "PM"
	else:
		hours -= 12
		time_label.text = str(hours) + ":" + str(minutes) + ":" + str(seconds)
		am_pm.text = "PM"

func date():
	# gets the dictionary of the current date fromt the system
	var current_date = Time.get_date_dict_from_system()
	
	var day = current_date.day
	var month = current_date.month
	var year = current_date.year
	
	var all_months = {
		1: "Jan",
		2: "Feb",
		3: "Mar",
		4: "Apr",
		5: "May",
		6: "Jun",
		7: "Jul",
		8: "Aug",
		9: "Sept",
		10: "Oct",
		11: "Nov",
		12: "Dec",
	}
	
	var mapped_month = all_months.get(month)
	date_label.text = str(day) +' ' + mapped_month + ' ' + str(year)

# date_update signal is catched here and a function to update the date is called
func _on_date_update() -> void:
	date()

# Date label toggling code
func _on_display_date_pressed():
	display_date_label()
	toggle_sound.play()

func display_date_label():
	date_opened = !date_opened
	if date_opened:
		date_label.visible = true
	else:
		date_label.visible = false
# ------------------------------------


func _on_about_min_time_pressed():
	about.show()
	toggle_sound.play()


func _on_close_pressed():
	about.hide()
	toggle_sound.play()


func _on_quit_pressed():
	get_tree().quit()
	
