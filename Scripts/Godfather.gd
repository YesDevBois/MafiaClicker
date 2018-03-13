extends TextureButton

var Godfathers = 0
var productionmultiplier = 10000
var costmultiplier
var basecost = 1000000
var cost
var respect
signal respect_from_godfathers


func _ready():
	# This allows spacebar to be used to for only incrementing F
	set_focus_mode(FOCUS_NONE)
	
	costmultiplier = 1.0  + (Godfathers*0.1)
	cost = basecost*costmultiplier


func _on_GlobalTimer_timeout():
	respect = productionmultiplier*Godfathers
	emit_signal("respect_from_godfathers", respect)


func _on_Godfather_pressed():
	Godfathers += 1
	costmultiplier = 1.0 + (Godfathers*0.1)
	cost = basecost*costmultiplier
	print("Godfathers:", Godfathers)

func _on_F_enable_button(me, boolval):
	if(me == 5):
		set_disabled(!boolval)
		
func save():
	var save_dict = {
		
		Godfathers = Godfathers
		
	}
	return save_dict
