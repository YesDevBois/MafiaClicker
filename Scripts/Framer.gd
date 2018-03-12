extends TextureButton

var Framers = 0
var productionmultiplier = 10
var costmultiplier = 1.0
var basecost = 1000
var cost = basecost*costmultiplier
var respect
signal respect_from_framers


func _ready():
	# This allows spacebar to be used to for only incrementing F
	set_focus_mode(FOCUS_NONE)



func _on_GlobalTimer_timeout():
	respect = productionmultiplier*Framers
	emit_signal("respect_from_framers", respect)


func _on_Framer_pressed():
	Framers += 1
	costmultiplier += 0.1
	cost = basecost*costmultiplier
	print("Framers:", Framers)

func _on_F_enable_button(me, boolval):
	if(me == 2):
		set_disabled(!boolval)