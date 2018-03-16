extends Button

func _ready():
	set_text("Quit game without saving?")
	

func _on_Hard_Quit_Button_pressed():
	get_tree().quit()
