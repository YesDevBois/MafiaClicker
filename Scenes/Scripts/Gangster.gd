extends TextureButton

var amount = 0
var productionmultiplier = 0.1
var costmultiplier
var basecost = 10
var cost
var respect
signal respect_from_gangsters

onready var Gangster_Amount_txt = get_node("Gangster_Gang_Size")
onready var Gangster_Cost_txt = get_node("Gangster_Cost")

func _ready():
	# This allows spacebar to be used to for only incrementing F
	set_focus_mode(FOCUS_NONE)
	costmultiplier = 1.0 + (amount*0.1)
	cost = basecost*costmultiplier
	
	print(amount)
	
	Gangster_Amount_txt.set_text(str(amount))
	Gangster_Cost_txt.set_text(str(cost))

#signal that triggers everytime the timer elapses, 1 second
#sends respect to the main button
func _on_GlobalTimer_timeout():
	respect = productionmultiplier*amount
	emit_signal("respect_from_gangsters", respect)

#signal to indicate the buying of a new button
#updates the amount of buttons, the cost multiplier
#and the total cost
func _on_Gangster_pressed():
	amount += 1
	costmultiplier = 1.0 + (amount*0.1)
	cost = basecost*costmultiplier
	Gangster_Amount_txt.set_text(str(amount))
	Gangster_Cost_txt.set_text(str(cost))
	get_parent().play_click_effect()

#gets the enable signal from the main button based on wallet amount
func _on_F_enable_button(me, boolval):
	if(me == 0):
		set_disabled(!boolval)

func save():
	var save_dict = {
		
		amount = amount
		
	}
	return save_dict

#all child nodes act exactly as this one with differing base cost