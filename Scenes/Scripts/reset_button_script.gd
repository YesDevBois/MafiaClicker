extends Button

const SAVE_PATH = "res://Saves/save.json"

func _ready():
	set_text("Press Here!")

func delete_game():
	var saved_game = File.new()
	var game_save_exists = ( saved_game.file_exists(SAVE_PATH) )
	
	if(game_save_exists == false):
		print("Game was not deleted.")
		saved_game.close()
		return
	else:
		var temp_dir = Directory.new()
		temp_dir.remove("res://Saves/save.json")
		print("Game was deleted.")
		
	saved_game.close()

func _on_Button_pressed():
	delete_game()
	pass
