extends TextureButton

var Consigs = 0
var productionmultiplier = 100
var costmultiplier
var basecost = 10000
var cost
var respect
signal respect_from_consigs


func _ready():
	# This allows spacebar to be used to for only incrementing F
	set_focus_mode(FOCUS_NONE)
	
	costmultiplier = 1.0 + (Consigs*0.1)
	cost = basecost*costmultiplier



func _on_GlobalTimer_timeout():
	respect = productionmultiplier*Consigs
	emit_signal("respect_from_consigs", respect)


func _on_Consig_pressed():
	Consigs += 1
	costmultiplier = 1.0 + (Consigs*0.1)
	cost = basecost*costmultiplier
	print("Consigs:", Consigs)

func _on_F_enable_button(me, boolval):
	if(me == 3):
		set_disabled(!boolval)
		
func save():
	var save_dict = {
		
		Consigs = Consigs
		
	}
	return save_dict
