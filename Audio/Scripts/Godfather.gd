extends TextureButton

### REMOTE

var amount = 0
var productionmultiplier = 10000
var costmultiplier
var basecost = 1000000
var cost
var respect
signal respect_from_godfathers

onready var F_button = get_parent()
onready var Godfather_Amount_txt = get_node("Godfather_Gang_Size")
onready var Godfather_Cost_txt = get_node("Godfather_Cost_Txt")

func _ready():
	# This allows spacebar to be used to for only incrementing F
	set_focus_mode(FOCUS_NONE)
	costmultiplier = 1.0  + (amount*0.1)
	cost = basecost*costmultiplier

	Godfather_Amount_txt.set_text(str(amount))
	Godfather_Cost_txt.set_text(str(cost))
	

func _on_GlobalTimer_timeout():
	respect = productionmultiplier*amount
	emit_signal("respect_from_godfathers", respect)

func formulate_cost(amt):
	var cst
	
	costmultiplier = 1.0 + (amt*0.1)
	cst = basecost*costmultiplier
	
	return cst

func txt_update():
	Godfather_Amount_txt.set_text(str(amount))
	Godfather_Cost_txt.set_text(str(cost))

func price_calc():
	F_button.set_price( F_button.get_buy_multi_cost(self) )
	amount += F_button.get_buy_multi_amt(self)
	cost = formulate_cost(amount)
	txt_update()
	get_parent().play_click_effect()

func _on_F_enable_button(me, boolval):
	if(me == 5):
		set_disabled(!boolval)

func save():
	var save_dict = {
		
		amount = amount
		
	}
	return save_dict