extends TextureButton

# tiny state machine based on multiplier for extraneous button use
var CURRENT_BUTTON_STATE = [0, 0.1, 0.25, 0.50, 1.0]

# buy multiplier, usable textures preloaded
const BUY_MULTI_USE_1 = preload("res://Images/multiplier_button/buy_multiplier_1_Usable.png")
const BUY_MULTI_USE_10 = preload("res://Images/multiplier_button/buy_multiplier_10p_Usable.png")
const BUY_MULTI_USE_25 = preload("res://Images/multiplier_button/buy_multiplier_25p_Usable.png")
const BUY_MULTI_USE_50 = preload("res://Images/multiplier_button/buy_multiplier_50p_Usable.png")
const BUY_MULTI_USE_100 = preload("res://Images/multiplier_button/buy_multiplier_100p_Usable.png")

# buy multiplier, pressed textures preloaded
var BUY_MULTI_PRESSED_1 = preload("res://Images/multiplier_button/buy_multiplier_1_Pressed.png")
var BUY_MULTI_PRESSED_10 = preload("res://Images/multiplier_button/buy_multiplier_10p_Pressed.png")
var BUY_MULTI_PRESSED_25 = preload("res://Images/multiplier_button/buy_multiplier_25p_Pressed.png")
var BUY_MULTI_PRESSED_50 = preload("res://Images/multiplier_button/buy_multiplier_50p_Pressed.png")
var BUY_MULTI_PRESSED_100 = preload("res://Images/multiplier_button/buy_multiplier_100p_Pressed.png")

# buy multiplier, hover textures preloaded
var BUY_MULTI_HOVER_1 = preload("res://Images/multiplier_button/buy_multiplier_1_Hover.png")
var BUY_MULTI_HOVER_10 = preload("res://Images/multiplier_button/buy_multiplier_10p_Hover.png")
var BUY_MULTI_HOVER_25 = preload("res://Images/multiplier_button/buy_multiplier_25p_Hover.png")
var BUY_MULTI_HOVER_50 = preload("res://Images/multiplier_button/buy_multiplier_50p_Hover.png")
var BUY_MULTI_HOVER_100 = preload("res://Images/multiplier_button/buy_multiplier_100p_Hover.png")

# arrays that hold these images
var buy_multi_use_arr = [BUY_MULTI_USE_1, BUY_MULTI_USE_10, BUY_MULTI_USE_25, BUY_MULTI_USE_50, BUY_MULTI_USE_100]
var buy_multi_pressed_arr = [BUY_MULTI_PRESSED_1, BUY_MULTI_PRESSED_10, BUY_MULTI_PRESSED_25, BUY_MULTI_PRESSED_50, BUY_MULTI_PRESSED_100]
var buy_multi_hover_arr = [BUY_MULTI_HOVER_1, BUY_MULTI_HOVER_10, BUY_MULTI_HOVER_25, BUY_MULTI_HOVER_50, BUY_MULTI_HOVER_100]

# should never be above this index
const MAX_INDEX = 4
# should never be below this index
const MIN_INDEX = 0

# just keeping track of the index
var index = 0

# wrapper function for these functions
func set_textures(idx):
	set_normal_texture(buy_multi_use_arr[idx])
	set_pressed_texture(buy_multi_pressed_arr[idx])
	set_hover_texture(buy_multi_hover_arr[idx])

func _ready():
	set_textures(0)
	CURRENT_BUTTON_STATE[0]

func _on_buyMultiplier_pressed():
	
	if( (index > MAX_INDEX) or (index < MIN_INDEX) ):
		index = 0
		CURRENT_BUTTON_STATE[index]
	elif(index == MAX_INDEX):
		index = 0
		CURRENT_BUTTON_STATE[index]
	elif(index < MAX_INDEX):
		index += 1
		CURRENT_BUTTON_STATE[index]
	
	set_textures(index)