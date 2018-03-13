extends Container

var sound = true
var sound_volume = 1.0
var music = true
var music_volume = 1.0
var popup_open = false

var settings_panel_pos = Vector2(0,0)
var screen_size = OS.get_screen_size()
var window_size = OS.get_window_size()

func _ready():
	print("Position, start: " + str(settings_panel_pos))
	
	# sets the position of the games into the middle of the computer screen
	OS.set_window_position((screen_size*0.5) - (window_size*0.5))

func _input(event):
	var s_key_pressed = event.is_action_pressed("ui_s_key")
	
	if(s_key_pressed):
		popup_open = !(popup_open)
		if(popup_open == true):
			print("The settings have been opened!")
			get_node("Settings_Panel").show()
		else:
			print("The settings have been closed!")
			get_node("Settings_Panel").hide()
		pass
		
