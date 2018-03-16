extends Particles2D

const PARTICLE_TEX_PATH = "res://Images/particles/p1_respect_particle_BLK-Outline.png"
onready var particle_amt = get_parent().particle_count

func _ready():
	set_use_local_coordinates(false)
	set_fixed_fps(60)
	set_randomness_ratio(1.0)
	set_lifetime(1.25)
	set_one_shot(true)
	set_emitting(true)

func _process(delta):
	if( !(is_emitting()) ):
		( get_parent().particle_count ) -= 1
		self.queue_free()
	else:
		return