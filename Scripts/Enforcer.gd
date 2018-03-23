extends TextureButton

var amount = 0
var productionmultiplier = 1
var costmultiplier
var basecost = 100
var cost
var respect
signal respect_from_enforcers

onready var F_button = get_parent()
onready var Enforcer_Amount_txt = get_node("Enforcer_Gang_Size")
onready var Enforcer_Cost_txt = get_node("Enforcer_Cost")


func _ready():
	# This allows spacebar to be used to for only incrementing F
	set_focus_mode(FOCUS_NONE)
	
	# set the texture to expand
	set_expand(true)
	
	costmultiplier = 1.0 + (amount*0.1)
	cost = basecost*costmultiplier
	
	Enforcer_Amount_txt.set_text(str(amount))
	Enforcer_Cost_txt.set_text(str(cost))


func _on_GlobalTimer_timeout():
	respect = productionmultiplier*amount
	emit_signal("respect_from_enforcers", respect)

func formulate_cost(amt):
	var cst
	
	costmultiplier = 1.0 + (amt*0.1)
	cst = basecost*costmultiplier
	
	return cst

func txt_update():
	Enforcer_Amount_txt.set_text(str(amount))
	Enforcer_Cost_txt.set_text(str(cost))

func price_calc():
	F_button.set_price( F_button.get_buy_multi_cost(self) )
	amount += F_button.get_buy_multi_amt(self)
	cost = formulate_cost(amount)
	txt_update()
	get_parent().play_click_effect()

func _on_F_enable_button(me, boolval):
	if(me == 1):
		set_disabled(!boolval)

func save():
	var save_dict = {
		
		amount = amount
		
	}
	return save_dict