extends CheckBox

func _on_LowProcessor_Box_toggled(button_pressed):
	OS.set_low_processor_usage_mode(true)
	OS.set_use_vsync(true) 
