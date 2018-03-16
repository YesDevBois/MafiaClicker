extends ConfirmationDialog

var cancel_button = get_cancel()
onready var resolution_button = get_parent()
var x_button = get_close_button()

func ok_pressed():
	resolution_button.change_resolution(resolution_button.current_res_index)
	resolution_button.previous_res_index = resolution_button.current_res_index
	get_tree().paused = false
func cancel_pressed():
	# changing variables back since they are changed every update in the
	# ResolutionButton _process function
	resolution_button.change_resolution(resolution_button.previous_res_index)
	resolution_button.current_res_index = resolution_button.previous_res_index
	resolution_button.select(resolution_button.previous_res_index)
	get_tree().paused = false

func _ready():
	dialog_hide_on_ok = true
	dialog_text = "Is this resolution okay?"
	cancel_button.connect("pressed", self, "cancel_pressed")
	x_button.connect("pressed", self, "cancel_pressed")

func _on_ConfirmationDialog_confirmed():
	ok_pressed()