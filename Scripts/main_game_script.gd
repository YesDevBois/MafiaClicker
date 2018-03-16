extends Control

var game_icon = load("res://Images/src/mafia_clicker_icon.png")
const SAVE_PATH = "res://Saves/save.json"

# saved period for keeping track of time
var time_out_period = 0
# time out coefficient to determine when to save
const time_out_coeff = 600

func quit_game():
	# closes the root scene, quitting the game.
	get_tree().quit()

func save_and_quit():
	save_game()
	quit_game()

# "func _input(event)" is a special function in Godot that polls the inputting
# device for information every frame.
func _input(event):
	# if the ESC key is pressed, call the "quit_game" function, ending the game
	if(event.is_action_pressed("ui_cancel")):
		save_and_quit()

func _notification(what):
	if(what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		save_and_quit()

# checks if the file exists or not
func check_file():
	var save_file = File.new()
	var file_exists = ( save_file.file_exists(SAVE_PATH) )
	
	if(file_exists):
		save_file.close()
		return true
	else:
		save_file.close()
		return false

func save_game():
	#Gets data from persistent nodes
	var save_dict = {}
	var nodes_to_save = get_tree().get_nodes_in_group('persistent')
	for node in nodes_to_save:
		save_dict[node.get_path()] = node.save()
	
	#create save file
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	
	save_file.store_line(to_json(save_dict))
	
	save_file.close()

func load_game():
	
	var save_file = File.new()
	var file_exists = ( save_file.file_exists(SAVE_PATH) )
	
	# try to load file, if not return
	if(file_exists == false):
		save_file.close()
		return
	
	save_file.open(SAVE_PATH, File.READ)
	var data = {}
	data = parse_json(save_file.get_as_text())
	
	for node_path in data.keys():
		var node = get_node(node_path)
		
		for attribute in data[node_path]:
			node.set(attribute, data[node_path][attribute])
	
	save_file.close()
	

# saves the game every ten minutes
func _on_GlobalTimer_timeout():
	# increment everytime the timer elapses
	time_out_period += 1
	
	# every 
	if(time_out_period == time_out_coeff):
		save_game()
		time_out_period = 0
		print("The game was autosaved.")
		return
	else:
		return

func _ready():
	get_tree().set_auto_accept_quit(false)
	OS.set_window_title("Mafia Clicker")
	OS.set_icon(game_icon)