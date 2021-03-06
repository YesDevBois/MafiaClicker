extends TextureButton

signal enable_button

onready var buy_multiplier_node = get_parent().get_node("buyMultiplier")
onready var buy_multiplier_index = buy_multiplier_node.index
onready var BUY_MULTI_STATE = buy_multiplier_node.get_button_state()
onready var F_button = self
onready var Gangster = get_node("Gangster")
onready var Enforcer = get_node("Enforcer")
onready var Framer = get_node("Framer")
onready var Consig = get_node("Consig")
onready var Hitman = get_node("Hitman")
onready var Godfather = get_node("Godfather")

const F_CLICKMASK_MIN = preload("res://Images/F_clickmask_tex_BASE.png")
const F_CLICKMASK_MID = preload("res://Images/F_clickmask_tex_MID.png")
const F_CLICKMASK_MAX = preload("res://Images/F_clickmask_tex_MAX.png")
var f_bitmask_array = [F_CLICKMASK_MIN, F_CLICKMASK_MID, F_CLICKMASK_MAX]

var resolution_array_F = [Vector2(469,355), Vector2(733,444), Vector2(879,533)]
var resolution_array_mob = [Vector2(496,96), Vector2(775,120), Vector2(930,144)]
var resolution_array_multi = [Vector2(330,96), Vector2(516,150), Vector2(619,180)]
var current_position_array = []

var savetime = 0
var wallet = 0.0
var lifetime_respect = 0.0
var price = 0
var first_open = true

var gangster_unlock = false
var enforcer_unlock = false
var consig_unlock = false
var framer_unlock = false
var hitman_unlock = false
var godfather_unlock = false

const GAME_BUTTONS = 6

func _ready():
	#unix time is used to calculate how long the game has been closed
	update_respect(savetime, OS.get_unix_time())
	
	BUY_MULTI_STATE = buy_multiplier_node.get_button_state()
	
	# set the texture to expand
	set_expand(true)
	
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
		wallet += (pow(10, 6)) - 1
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
	#print("BUY_MULTI_STATE := ", BUY_MULTI_STATE)
	
	if(BUY_MULTI_STATE == 0):
		
		return 1
		
	else:
		
		while(temp_cost <= (wallet * BUY_MULTI_STATE) ):
			
			temp_cost += button_node.formulate_cost(button_node.amount+iteration)
			
			if(temp_cost < (wallet * BUY_MULTI_STATE)):
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
	set_wallet(wallet - price)

func _on_Enforcer_respect_from_enforcers(respect):
	wallet += respect
func _on_Enforcer_pressed():
	Enforcer.price_calc()
	price = get_price()
	set_wallet(wallet - price)

func _on_Framer_respect_from_framers(respect):
	wallet += respect
func _on_Framer_pressed():
	Framer.price_calc()
	price = get_price()
	set_wallet(wallet - price)

func _on_Consig_respect_from_consigs(respect):
	wallet += respect
func _on_Consig_pressed():
	Consig.price_calc()
	price = get_price()
	set_wallet(wallet - price)

func _on_Hitman_respect_from_hitmen(respect):
	wallet += respect
func _on_Hitman_pressed():
	Hitman.price_calc()
	price = get_price()
	set_wallet(wallet - price)

func _on_Godfather_respect_from_godfathers(respect):
	wallet += respect
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

func reposition_buttons(idx):
	var nodes = get_children()
	var nodes_text = []
	
	var nodes_wallet = nodes[6]
	var tempbutton_pos = Vector2(0,0)
	var tempmulti_pos = Vector2(0,0)
	var tempwallet_pos = Vector2(0,0)
	
	if(idx == 0):
		tempmulti_pos = Vector2(50,550)
		tempwallet_pos = Vector2(180,360)
		buy_multiplier_node.set_global_position(tempmulti_pos)
		nodes_wallet.set_global_position(tempwallet_pos)
		
		
		for i in GAME_BUTTONS:
			tempbutton_pos.x = 514
			
			nodes_text = nodes[i].get_children()
			nodes_text[0].set_position(Vector2(380,55))
			nodes_text[1].set_position(Vector2(330,20))
			
			tempbutton_pos.y = (i * 116) + 16
			nodes[i].set_global_position(tempbutton_pos)
	elif(idx == 1):
		tempmulti_pos = Vector2(50,730)
		tempwallet_pos = Vector2(180,450)
		buy_multiplier_node.set_global_position(tempmulti_pos)
		nodes_wallet.set_global_position(tempwallet_pos)
		
		
		for i in GAME_BUTTONS:
			nodes_text = nodes[i].get_children()
			nodes_text[0].set_position(Vector2(588,73))
			nodes_text[1].set_position(Vector2(538,25))
			
			tempbutton_pos.x = 1586 - resolution_array_mob[idx].x
			tempbutton_pos.y = (i * (resolution_array_mob[idx].y + 20) ) + 16
			nodes[i].set_global_position(tempbutton_pos)
	else:
		tempmulti_pos = Vector2(50,910)
		tempwallet_pos = Vector2(180,540)
		buy_multiplier_node.set_global_position(tempmulti_pos)
		nodes_wallet.set_global_position(tempwallet_pos)
		
		for i in GAME_BUTTONS:
			nodes_text = nodes[i].get_children()
			nodes_text[0].set_position(Vector2(710,85))
			nodes_text[1].set_position(Vector2(660,35))
			
			tempbutton_pos.x = 1906 - resolution_array_mob[idx].x
			tempbutton_pos.y = (i * (resolution_array_mob[idx].y + 20) ) + 16
			nodes[i].set_global_position(tempbutton_pos)

func set_current_pos():
	var nodes = get_children()
	
	for i in GAME_BUTTONS+1:
		current_position_array[i] = nodes[i].get_global_position()

func set_resolution_nodes(idx):
	var nodes = get_children()
	
	set_size(resolution_array_F[idx])
	buy_multiplier_node.set_size(resolution_array_multi[idx])
	set_click_mask(f_bitmask_array[idx])
	
	for i in GAME_BUTTONS:
		nodes[i].set_size(resolution_array_mob[idx])

func _on_ResolutionButton_resolution_changed(current_resolution,idx):
	set_resolution_nodes(idx)
	reposition_buttons(idx)
