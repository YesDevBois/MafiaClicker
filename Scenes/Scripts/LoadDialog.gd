extends AcceptDialog

onready var F_button = get_parent()

func _ready():
	set_title("Welcome back!")
	set_resizable(false)
	hide()
	dialog_hide_on_ok = true

func activate_dialog(primed, afk_res):
	if(primed):
		set_text("You earned " + str(afk_res) + " respect while away!")
		get_tree().paused = true
		show()
	else:
		return

func _on_AFK_Respect_Dialog_confirmed():
	get_tree().paused = false
