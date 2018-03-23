extends HSlider

onready var ROOT_NODE = get_tree().get_root().get_node("ROOT")
onready var F_button = ROOT_NODE.get_node("F")
onready var clap_efx = F_button.get_node("Snap_Effect")
onready var music_stream = F_button.get_node("Background_Music_Stream")
onready var music_slider = get_node("Music_Volume_Slider")
onready var music_box = get_node("MuteMusicBox")
onready var sfx_box = get_node("MuteSoundBox")

const MIN_VOLUME = -80.0
const MAX_VOLUME = 10.0
const TICK_VAL = 20
const STEP_VAL = 10.0

var current_sfx_vol = 0.0
var current_music_vol = 0.0
var music_mute_pressed = false
var sfx_mute_pressed = false

func _ready():
	set_editable(true)
	set_ticks_on_borders(true)
	set_use_rounded_values(true) 
	
	# this is the gui white lines, explicitly for aesthetic purposes
	set_ticks(TICK_VAL)
	
	# THIS IS THE REAL STUFF HERE
	set_step(STEP_VAL)
	
	sfx_box.set_pressed(sfx_mute_pressed)
	music_box.set_pressed(music_mute_pressed)
	clap_efx.set_volume_db(current_sfx_vol)
	music_stream.set_volume_db(current_music_vol)
	
	music_slider.set_value(music_stream.get_volume_db())
	set_value(clap_efx.get_volume_db())
	
	_on_MuteMusicBox_toggled(music_mute_pressed)
	print("sfx_mute_pressed IS: ", sfx_mute_pressed)
	_on_MuteSoundBox_toggled(sfx_mute_pressed)

func _on_SFX_Volume_Slider_value_changed(value):
	var volume = get_value()
	clap_efx.play()
	current_sfx_vol = volume
	clap_efx.set_volume_db(volume)

func _on_MuteSoundBox_toggled(button_pressed):
	sfx_mute_pressed = button_pressed
	
	if(sfx_mute_pressed):
		clap_efx.set_volume_db(MIN_VOLUME)
		clap_efx.play()
	else:
		clap_efx.set_volume_db(current_sfx_vol)

func _on_MuteMusicBox_toggled(button_pressed):
	music_mute_pressed = button_pressed
	
	if(music_mute_pressed):
		music_stream.stop()
	else:
		music_stream.play()

func save():
	var save_dict = {
		current_sfx_vol = current_sfx_vol,
		current_music_vol = current_music_vol,
		music_mute_pressed = music_mute_pressed,
		sfx_mute_pressed = sfx_mute_pressed
	}
	return save_dict