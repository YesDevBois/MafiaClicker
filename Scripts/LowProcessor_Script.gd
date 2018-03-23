extends CheckBox

var low_processor_flag = false

func _ready():
	set_pressed(low_processor_flag)
	_on_LowProcessor_Box_toggled(low_processor_flag)

func _on_LowProcessor_Box_toggled(button_pressed):
	low_processor_flag = button_pressed
	
	OS.set_low_processor_usage_mode(low_processor_flag)
	OS.set_use_vsync(low_processor_flag) 

func save():
	var save_dict = {
		low_processor_flag = low_processor_flag
	}
	return save_dict