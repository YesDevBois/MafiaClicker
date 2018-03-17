extends TextureButton

signal enable_button

onready var buy_multiplier_node = get_parent().get_node("buyMultiplier")
onready var buy_multiplier_index = buy_multiplier_node.index
onready var BUY_MULTI_STATE = buy_multiplier_node.CURRENT_BUTTON_STATE

var savetime = 0
var wallet = 0.0
var lifetime_respect = 0.0
var first_open = true
var price = 0

var gangster_unlock = false
var enforcer_unlock = false
var consig_unlock = false
var framer_unlock = false
var hitman_unlock = false
var godfather_unlock = false

onready var Gangster = get_node("Gangster")
onready var Enforcer = get_node("Enforcer")
onready var Framer = get_node("Framer")
onready var Consig = get_node("Consig")
onready var Hitman = get_node("Hitman")
onready var Godfather = get_node("Godfather")

const GAME_BUTTONS = 6

func _ready():
	#unix time is used to calculate how long the game has been closed
	update_respect(savetime, OS.get_unix_time())
	
	BUY_MULTI_STATE[buy_multiplier_index]
	
	# This allows spacebar to be used for only incrementing F
	set_focus_mode(FOCUS_ALL)
	grab_focus()
	
	Gangster.hide()
	Enforcer.hide()
	Framer.hide()
	Consig.hide()
	Hitman.hide()
	Godfather.hide()
	
	
	if( Gangster.amount > 0):
		Gangster.show()
	
	if(Enforcer.amount > 0):
		Enforcer.show()
	
	if(Framer.amount > 0):
		Framer.show()
		
	if(Consig.amount > 0):
		Consig.show()
		
	if(Hitman.amount > 0):
		Hitman.show()
	
	if( Godfather.amount > 0):
		Godfather.show()
		

#every frame checks to if any button can be enabled
#enables if wallet >= button.cost, disables if not
func _process(delta):
	
	if(wallet >= Gangster.cost):
		Gangster.show()
		gangster_unlock = true
		enable_gangster(true)
	elif((wallet < Gangster.cost) and (gangster_unlock == true)):
		enable_gangster(false)
	
	if(wallet >= Enforcer.cost):
		Enforcer.show()
		enable_enforcer(true)
		enforcer_unlock = true
	elif((wallet < Enforcer.cost) and (enforcer_unlock == true)):
		enable_enforcer(false)
	
	if(wallet >= Framer.cost):
		Framer.show()
		enable_framer(true)
		framer_unlock = true
	elif((wallet < Framer.cost) and (framer_unlock == true)):
		enable_framer(false)
		
	if(wallet >= Consig.cost):
		Consig.show()
		enable_consig(true)
		consig_unlock = true
	elif((wallet < Consig.cost) and (consig_unlock == true)):
		enable_consig(false)
		
	if(wallet >= Hitman.cost):
		Hitman.show()
		enable_hitman(true)
		hitman_unlock = true
	elif((wallet < Hitman.cost) and (hitman_unlock == true)):
		enable_hitman(false)
	
	if(wallet >= Godfather.cost):
		Godfather.show()
		enable_godfather(true)
		godfather_unlock = true
	elif((wallet < Godfather.cost) and (godfather_unlock == true)):
		enable_godfather(false)

func play_click_effect():
	get_node("Snap_Effect").play()

#increases respect count everytime you click the F button
func _on_F_pressed():
	wallet += 1
	play_click_effect()
	get_node("particle_pos").emit_on_mPress()
	print(wallet)
#can also increase wallet with the space bar 
func _input(event):
	
	# when it comes to GUI input and the keyboard, GODOT has a system that polls
	# for the "currently selected button" this is called the "focus". If a focus
	# is not defined, then the previous selection will be used instead. It will
	# then execute whatever the function has defined "on_pressed()". Since we
	# want the spacebar to be an alternative increment method, we must ensure the
	# other buttons are unable to grab focus and ensure ONLY the F button has
	# the focus at any given time. We also remove the "wallet += 1" operation,
	# because, as stated previously, the button press will execute whatever is
	# defined on the button press, AND THEN whatever is defined under the
	# "is_action_pressed" action. Putting the operation there would, in effect,
	# give two respect instead of one. Which we do not want.
	if(event.is_action_released("key_spacebar")):
		wallet += (pow(10, 3)) - 1
		print("#####DEBUG##### RESPECT INCREASED BY ONE MILLION! WALLET IS NOW: " + str(wallet))
		return

#signals that enable their respective buttons
func enable_gangster(boolval):
	emit_signal("enable_button", 0, boolval)

func enable_enforcer(boolval):
	emit_signal("enable_button", 1, boolval)

func enable_framer(boolval):
	emit_signal("enable_button", 2, boolval)

func enable_consig(boolval):
	emit_signal("enable_button", 3, boolval)

func enable_hitman(boolval):
	emit_signal("enable_button", 4, boolval)

func enable_godfather(boolval):
	emit_signal("enable_button", 5, boolval)

func set_price(value):
	price = value
	return price
func get_price():
	return price

# calculate the COST a button class is to be bought relative to the multiplier
func get_buy_multi_cost(button_node):
	
	var able_to_buy = get_buy_multi_amt(button_node)
	var temp_cost = 0.0
	var current_amt = button_node.amount
	
	if(able_to_buy == 1):
		return button_node.formulate_cost(current_amt)
	else:
		for i in (able_to_buy):
			temp_cost += button_node.formulate_cost(current_amt+i)
		
		return temp_cost

# calculate the AMOUNT a button class is to be bought relative to the multiplier
func get_buy_multi_amt(button_node):
	var temp_cost = 0.0
	var iteration = 0
	
	BUY_MULTI_STATE[buy_multiplier_index] = buy_multiplier_node.CURRENT_BUTTON_STATE[buy_multiplier_node.index]
	#print("BUY_MULTI_STATE := ", BUY_MULTI_STATE[buy_multiplier_index])
	
	if(BUY_MULTI_STATE[buy_multiplier_index] == 0):
		
		return 1
		
	else:
		
		while(temp_cost <= (wallet * buy_multiplier_node.CURRENT_BUTTON_STATE[buy_multiplier_index]) ):
			
			temp_cost += button_node.formulate_cost(button_node.amount+iteration)
			
			if(temp_cost < (wallet * buy_multiplier_node.CURRENT_BUTTON_STATE[buy_multiplier_index])):
				iteration += 1
				continue
			else:
				break
		
	return iteration

#signal recievers for updating wallet based on the production of the buttons
#of the buttons and if anymore buttons are bought
func _on_Gangster_respect_from_gangsters(respect):
	wallet += respect
func _on_Gangster_pressed():
	Gangster.price_calc()
	price = get_price()
	wallet -= price

func _on_Enforcer_respect_from_enforcers(respect):
	wallet += respect
func _on_Enforcer_pressed():
	Enforcer.price_calc()
	price = get_price()
	wallet -= Enforcer.cost

func _on_Framer_respect_from_framers(respect):
	wallet += respect
func _on_Framer_pressed():
	Framer.price_calc()
	price = get_price()
	wallet -= Framer.cost

func _on_Consig_respect_from_consigs(respect):
	wallet += respect
func _on_Consig_pressed():
	Consig.price_calc()
	price = get_price()
	wallet -= Consig.cost

func _on_Hitman_respect_from_hitmen(respect):
	wallet += respect
func _on_Hitman_pressed():
	Hitman.price_calc()
	price = get_price()
	wallet -= Hitman.cost

func _on_Godfather_respect_from_godfathers(respect):
	wallet += respect
func _on_Godfather_pressed():
	Godfather.price_calc()
	price = get_price()
	wallet -= Godfather.cost

func _on_buyMultiplier_pressed():
	play_click_effect()

#updates wallet to reflect the amount of respect earned while away
func update_respect(savetime, loadtime):
	var nodes = get_children()
	var afkrespect = 0.0
	
	# we subtract nodes.size() by two, because the last two children of "F" are not buttons
	# so they do not have the variables we need to do the afkrespect calculation
	for i in range(0, GAME_BUTTONS ):
		afkrespect += ( (nodes[i].productionmultiplier) * (nodes[i].amount) ) * (loadtime-savetime)
	
	wallet += afkrespect
	
	if(first_open):
		return
	else:
		get_node("AFK_Respect_Dialog").activate_dialog(true, afkrespect)

#saves the total respect earned and the time the game was closed
func save():
	savetime = OS.get_unix_time()
	var save_dict = {
		first_open = false,
		wallet = wallet,
		savetime = savetime
	}
	return save_dict