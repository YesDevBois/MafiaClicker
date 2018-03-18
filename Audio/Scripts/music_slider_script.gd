extends HSlider

onready var ROOT_NODE = get_tree().get_root().get_node("ROOT")
onready var F_button = ROOT_NODE.get_node("F")
onready var music_stream = F_button.get_node("Background_Music_Stream")

const MIN_VOLUME = -80.0
const MAX_VOLUME = 10.0
const TICK_VAL = 20
const STEP_VAL = 2.0

func _ready():
	set_editable(true)
	set_ticks_on_borders(true)
	set_use_rounded_values(true) 
	
	# this is the gui white lines, explicitly for aesthetic purposes
	set_ticks(TICK_VAL)
	
	# THIS IS THE REAL STUFF HERE
	set_step(STEP_VAL)
	
	set_value(music_stream.get_volume_db())

func _on_Music_Volume_Slider_value_changed(value):
	var volume = get_value()
	music_stream.set_volume_db(volume)