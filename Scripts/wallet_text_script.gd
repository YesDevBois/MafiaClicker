extends Label

var wallet_amt = 0

func _ready():
	add_color_override("font_color", Color(1,1,1,1))

func _process(delta):
	wallet_amt = get_parent().wallet
	set_text("Respect: " + str(wallet_amt))
	