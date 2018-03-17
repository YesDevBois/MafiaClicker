extends TextureButton

signal enable_button

var savetime = 0

var wallet = 0.0
var lifetime_respect = 0.0
var first_open = true

var gangster_unlock = false
var enforcer_unlock = false
var consig_unlock = false
var framer_unlock = false
var hitman_unlock = false
var godfather_unlock = false

onready var Gangster = get_child(0)
onready var Enforcer = get_child(1)
onready var Framer = get_child(2)
onready var Consig = get_child(3)
onready var Hitman = get_child(4)
onready var Godfather = get_child(5)

func _ready():
	#unix time is used to calculate how long the game has been closed
	update_respect(savetime, OS.get_unix_time())
	
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
	get_node("Clap_Effect").play(0.0)

func set_p1_particle():
	pass

func emit_p1_particle():
	var local_pos = Vector2(0,0)
	local_pos = ( get_viewport().get_mouse_position() )
	print(local_pos)
	get_node("REFERENCE_DO_NOT_USE").restart()
	pass

#increases respect count everytime you click the F button
func _on_F_pressed():
	wallet += 1
	play_click_effect()
	emit_p1_particle()
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
		wallet += (pow(10, 6))
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

#signal recievers for updating wallet based on the production of the buttons
#of the buttons and if anymore buttons are bought
func _on_Gangster_respect_from_gangsters(respect):
	wallet += respect
func _on_Gangster_pressed():
	wallet -= Gangster.cost

func _on_Enforcer_respect_from_enforcers(respect):
	wallet += respect
func _on_Enforcer_pressed():
	wallet -= Enforcer.cost

func _on_Framer_respect_from_framers(respect):
	wallet += respect
func _on_Framer_pressed():
	wallet -= Framer.cost

func _on_Consig_respect_from_consigs(respect):
	wallet += respect
func _on_Consig_pressed():
	wallet -= Consig.cost

func _on_Hitman_respect_from_hitmen(respect):
	wallet += respect
func _on_Hitman_pressed():
	wallet -= Hitman.cost

func _on_Godfather_respect_from_godfathers(respect):
	wallet += respect
func _on_Godfather_pressed():
	wallet -= Godfather.cost

#updates wallet to reflect the amount of respect earned while away
func update_respect(savetime, loadtime):
	var nodes = get_children()
	var afkrespect = 0.0
	
	# we subtract nodes.size() by two, because the last two children of "F" are not buttons
	# so they do not have the variables we need to do the afkrespect calculation
	for i in range(0, (nodes.size() - 4) ):
		afkrespect += ( (nodes[i].productionmultiplier) * (nodes[i].amount) ) * (loadtime-savetime)
	
	print("###DEBUG### Respect earned while gone: ", afkrespect)
	
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