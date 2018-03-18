extends TextureButton

signal enable_button

onready var buy_multiplier_node = get_parent().get_node("buyMultiplier")
onready var buy_multiplier_index = buy_multiplier_node.index
onready var BUY_MULTI_STATE = buy_multiplier_node.get_button_state()

var savetime = 0
var wallet = 0.0
var lifetime_respect = 0.0
var first_open = true
var price = 0

var gangster_unlocked = false
var enforcer_unlocked = false
var consig_unlocked = false
var framer_unlocked = false
var hitman_unlocked = false
var godfather_unlocked = false

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
	
	BUY_MULTI_STATE = buy_multiplier_node.get_button_state()
	
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
	
	var current_wallet = get_wallet()
	
	if(current_wallet >= Gangster.cost):
		enable_gangster(true)
		Gangster.show()
		gangster_unlocked = true
	elif((current_wallet < Gangster.cost) and (gangster_unlocked == true)):
		enable_gangster(false)
	
	if(current_wallet >= Enforcer.cost):
		Enforcer.show()
		enable_enforcer(true)
		enforcer_unlocked = true
	elif((current_wallet < Enforcer.cost) and (enforcer_unlocked == true)):
		enable_enforcer(false)
	
	if(current_wallet >= Framer.cost):
		Framer.show()
		enable_framer(true)
		framer_unlocked = true
	elif((current_wallet < Framer.cost) and (framer_unlocked == true)):
		enable_framer(false)
		
	if(current_wallet >= Consig.cost):
		Consig.show()
		enable_consig(true)
		consig_unlocked = true
	elif((current_wallet < Consig.cost) and (consig_unlocked == true)):
		enable_consig(false)
		
	if(current_wallet >= Hitman.cost):
		Hitman.show()
		enable_hitman(true)
		hitman_unlocked = true
	elif((current_wallet < Hitman.cost) and (hitman_unlocked == true)):
		enable_hitman(false)
	
	if(current_wallet >= Godfather.cost):
		Godfather.show()
		enable_godfather(true)
		godfather_unlocked = true
	elif((current_wallet < Godfather.cost) and (godfather_unlocked == true)):
		enable_godfather(false)

func play_click_effect():
	get_node("Snap_Effect").play()

#increases respect count everytime you click the F button
func _on_F_pressed():
	set_wallet(wallet + 1)
	play_click_effect()
	get_node("particle_pos").emit_on_mPress()
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
	if(event.is_action_released("ui_accept")):
		wallet += (pow(10, 6)) - 1
		print("#####DEBUG##### RESPECT INCREASED BY ONE MILLION! WALLET IS NOW: " + str(wallet))

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
func set_wallet(value):
	wallet = value
func get_wallet():
	return wallet

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
	
	BUY_MULTI_STATE = buy_multiplier_node.get_button_state()
	
	if(BUY_MULTI_STATE == 0):
		
		return 1
		
	else:
		
		while(temp_cost <= (wallet * BUY_MULTI_STATE) ):
			
			temp_cost += button_node.formulate_cost(button_node.amount+iteration)
			
			if(temp_cost <= (wallet * BUY_MULTI_STATE)):
				iteration += 1
				continue
			else:
				break
		
	return iteration

#signal recievers for updating wallet based on the production of the buttons
#of the buttons and if anymore buttons are bought
func _on_Gangster_respect_from_gangsters(respect):
	set_wallet( respect + get_wallet() )
func _on_Gangster_pressed():
	Gangster.price_calc()
	price = get_price()
	set_wallet(wallet - price)

func _on_Enforcer_respect_from_enforcers(respect):
	set_wallet( respect + get_wallet() )
func _on_Enforcer_pressed():
	Enforcer.price_calc()
	price = get_price()
	set_wallet(wallet - price)

func _on_Framer_respect_from_framers(respect):
	set_wallet( respect + get_wallet() )
func _on_Framer_pressed():
	Framer.price_calc()
	price = get_price()
	set_wallet(wallet - price)

func _on_Consig_respect_from_consigs(respect):
	set_wallet( respect + get_wallet() )
func _on_Consig_pressed():
	Consig.price_calc()
	price = get_price()
	set_wallet(wallet - price)

func _on_Hitman_respect_from_hitmen(respect):
	set_wallet( respect + get_wallet() )
func _on_Hitman_pressed():
	Hitman.price_calc()
	price = get_price()
	set_wallet(wallet - price)

func _on_Godfather_respect_from_godfathers(respect):
	set_wallet( respect + get_wallet() )
func _on_Godfather_pressed():
	Godfather.price_calc()
	price = get_price()
	set_wallet(wallet - price)

func _on_buyMultiplier_pressed():
	BUY_MULTI_STATE = buy_multiplier_node.get_button_state()
	play_click_effect()

#updates wallet to reflect the amount of respect earned while away
func update_respect(savetime, loadtime):
	var nodes = get_children()
	var afkrespect = 0.0
	var current_wallet = get_wallet()
	
	for i in range(0, GAME_BUTTONS):
		afkrespect += (nodes[i].productionmultiplier) * (nodes[i].amount)
	
	afkrespect *= (loadtime - savetime)
	set_wallet(current_wallet + afkrespect)
	
	if(get_wallet() == 0):
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