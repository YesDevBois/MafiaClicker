extends TextureButton

signal enable_button

var savetime = 0

var wallet = 0

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
	
	# This allows spacebar to be used to for only incrementing F
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
		
	#unix time is used to calculate how long the game has been closed
	update_respect(savetime, OS.get_unix_time())
	
	
		
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

#increases respect count everytime you click the F button
func _on_F_pressed():
	wallet += 1
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
	if(respect > 0):
		print(wallet)
func _on_Gangster_pressed():
	wallet -= Gangster.cost
	print(wallet)


func _on_Enforcer_respect_from_enforcers(respect):
	wallet += respect
	if(respect > 0):
		print(wallet)
func _on_Enforcer_pressed():
	wallet -= Enforcer.cost
	print(wallet)


func _on_Framer_respect_from_framers(respect):
	wallet += respect
	if(respect > 0):
		print(wallet)
func _on_Framer_pressed():
	wallet -= Framer.cost
	print(wallet)


func _on_Consig_respect_from_consigs(respect):
	wallet += respect
	if(respect > 0):
		print(wallet)
func _on_Consig_pressed():
	wallet -= Consig.cost
	print(wallet)


func _on_Hitman_respect_from_hitmen(respect):
	wallet += respect
	if(respect > 0):
		print(wallet)
func _on_Hitman_pressed():
	wallet -= Hitman.cost
	print(wallet)


func _on_Godfather_respect_from_godfathers(respect):
	wallet += respect
	if(respect > 0):
		print(wallet)
func _on_Godfather_pressed():
	wallet -= Godfather.cost
	print(wallet)

#updates wallet to reflect the amount of respect earned while away
func update_respect(savetime, loadtime):
	var nodes = get_children()
	var afkrespect = 0
	for i in range(0, nodes.size()-1):
		afkrespect += (nodes[i].productionmultiplier*nodes[i].amount)*(loadtime-savetime)
	
	print("Respect earned while gone:", afkrespect)
	
	wallet += afkrespect
	
	
#saves the total respect earned and the time the game was closed
func save():
	savetime = OS.get_unix_time()
	var save_dict = {
		
		wallet = wallet,
		savetime = savetime
		
	}
	return save_dict
