extends TextureButton

var Enforcers = 0
var productionmultiplier = 1
var costmultiplier
var basecost = 100
var cost
var respect
signal respect_from_enforcers

onready var Enforcer_Amount_txt = get_node("Enforcer_Gang_Size")
onready var Enforcer_Cost_txt = get_node("Enforcer_Cost")


func _ready():
	# This allows spacebar to be used to for only incrementing F
	set_focus_mode(FOCUS_NONE)
	
	costmultiplier = 1.0 + (Enforcers*0.1)
	cost = basecost*costmultiplier
	
	Enforcer_Amount_txt.set_text(str(Enforcers))
	Enforcer_Cost_txt.set_text(str(cost))


func _on_GlobalTimer_timeout():
	respect = productionmultiplier*Enforcers
	emit_signal("respect_from_enforcers", respect)


func _on_Enforcer_pressed():
	Enforcers += 1
	costmultiplier = 1.0 + (Enforcers*0.1)
	cost = basecost*costmultiplier
	Enforcer_Amount_txt.set_text(str(Enforcers))
	Enforcer_Cost_txt.set_text(str(cost))
	print("Enforcers:", Enforcers)

func _on_F_enable_button(me, boolval):
	if(me == 1):
		set_disabled(!boolval)

func save():
	var save_dict = {
		
		Enforcers = Enforcers
		
	}
	return save_dict
