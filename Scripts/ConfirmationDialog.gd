extends ConfirmationDialog

var cancel_button = get_cancel()
var x_button = get_close_button()
onready var resolution_button = get_parent()

func ok_pressed():
	resolution_button.change_resolution(resolution_button.current_res_index)
	resolution_button.dropdown_selected = resolution_button.current_res_index
	resolution_button.previous_res_index = resolution_button.current_res_index
	get_tree().paused = false
func cancel_pressed():
	# changing variables back since they are changed every update in the
	# ResolutionButton _process function
	resolution_button.change_resolution(resolution_button.previous_res_index)
	resolution_button.current_res_index = resolution_button.previous_res_index
	resolution_button.dropdown_selected = resolution_button.previous_res_index
	resolution_button.select(resolution_button.previous_res_index)
	get_tree().paused = false

func _ready():
	var confirmation_dialog = self
	
	dialog_hide_on_ok = true
	dialog_text = "Is this resolution okay?"
	cancel_button.connect("pressed", self, "cancel_pressed")
	x_button.connect("pressed", self, "cancel_pressed")

func _on_ConfirmationDialog_confirmed():
	ok_pressed()
