extends Timer

#timer elapses every second sends a signal each time it elapses
func Times_Up():
	emit_signal("timeout")