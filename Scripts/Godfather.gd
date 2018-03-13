extends TextureButton

var amount = 0
var productionmultiplier = 10000
var costmultiplier
var basecost = 1000000
var cost
var respect
signal respect_from_godfathers


func _ready():
	# This allows spacebar to be used to for only incrementing F
	set_focus_mode(FOCUS_NONE)
	
	costmultiplier = 1.0  + (amount*0.1)
	cost = basecost*costmultiplier


func _on_GlobalTimer_timeout():
	respect = productionmultiplier*amount
	emit_signal("respect_from_godfathers", respect)


func _on_Godfather_pressed():
	amount += 1
	costmultiplier = 1.0 + (amount*0.1)
	cost = basecost*costmultiplier
	print("Godfathers:", amount)

func _on_F_enable_button(me, boolval):
	if(me == 5):
		set_disabled(!boolval)
		
func save():
	var save_dict = {
		
		amount = amount
		
	}
	return save_dict
