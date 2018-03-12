extends ConfirmationDialog

var cancel_button = get_cancel()
onready var resolution_button = get_parent()

func ok_wrapper():
	print("Made it to the OKAY wrapper.")
	resolution_button.change_resolution(resolution_button.current_res_index)
	resolution_button.previous_res_index = resolution_button.current_res_index
	#Root.reorient_settings_panel(screen_resolution)
	get_tree().paused = false
func cancel_wrapper():
	# changing variables back since they are changed every update in the
	# ResolutionButton _process function
	resolution_button.change_resolution(resolution_button.previous_res_index)
	resolution_button.current_res_index = resolution_button.previous_res_index
	resolution_button.select(resolution_button.previous_res_index)
	print("Made it to the CANCEL wrapper.")
	get_tree().paused = false

func _ready():
	dialog_hide_on_ok = true
	dialog_text = "Is this resolution okay?"
	cancel_button.connect("pressed", self, "cancel_wrapper")

func _on_ConfirmationDialog_confirmed():
	ok_wrapper()