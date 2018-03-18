extends HSlider

onready var ROOT_NODE = get_tree().get_root().get_node("ROOT")
onready var F_button = ROOT_NODE.get_node("F")
onready var clap_efx = F_button.get_node("Snap_Effect")
onready var music_stream = F_button.get_node("Background_Music_Stream")

const MIN_VOLUME = -80.0
const MAX_VOLUME = 10.0
const TICK_VAL = 20
const STEP_VAL = 10.0

var last_song_pos = 0.0

func _ready():
	set_editable(true)
	set_ticks_on_borders(true)
	set_use_rounded_values(true) 
	
	# this is the gui white lines, explicitly for aesthetic purposes
	set_ticks(TICK_VAL)
	
	# THIS IS THE REAL STUFF HERE
	set_step(STEP_VAL)
	
	set_value(clap_efx.get_volume_db())

func _on_SFX_Volume_Slider_value_changed(value):
	var volume = get_value()
	clap_efx.play()
	clap_efx.set_volume_db(volume)


func _on_MuteSoundBox_toggled(button_pressed):
	clap_efx.set_volume_db(MIN_VOLUME)
	clap_efx.play()


func _on_MuteMusicBox_toggled(button_pressed):
	last_song_pos = music_stream.get_playback_position()
	
	if(button_pressed):
		music_stream.stop()
	else:
		music_stream.play(last_song_pos)
