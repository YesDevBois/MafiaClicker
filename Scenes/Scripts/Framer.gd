extends TextureButton

### REMOTE

var amount = 0
var productionmultiplier = 10
var costmultiplier
var basecost = 1000
var cost
var respect
signal respect_from_framers

onready var Framer_Amount_txt = get_node("Framer_Gang_Size")
onready var Framer_Cost_txt = get_node("Framer_Cost_Txt")


func _ready():
	# This allows spacebar to be used to for only incrementing F
	set_focus_mode(FOCUS_NONE)
	costmultiplier = 1.0 + (amount*0.1)
	cost = basecost*costmultiplier

	Framer_Amount_txt.set_text(str(amount))
	Framer_Cost_txt.set_text(str(cost))
	

func _on_GlobalTimer_timeout():
	respect = productionmultiplier*amount
	emit_signal("respect_from_framers", respect)


func _on_Framer_pressed():
	amount += 1
	costmultiplier = 1.0 + (amount*0.1)
	cost = basecost*costmultiplier
	Framer_Amount_txt.set_text(str(amount))
	Framer_Cost_txt.set_text(str(cost))
	get_parent().play_click_effect()

func _on_F_enable_button(me, boolval):
	if(me == 2):
		set_disabled(!boolval)
		
func save():
	var save_dict = {
		
		amount = amount
		
	}
	return save_dict