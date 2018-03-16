extends Position2D

const MAX_PARTICLE_AMT = 10
var particle_count = 0
var particle_scene = load("res://Scenes/click_p1_particle.tscn")

func emit_on_mPress():
	set_position(get_viewport().get_mouse_position())
	var particle_effect = particle_scene.instance()
	
	if(particle_count <= MAX_PARTICLE_AMT):
		add_child(particle_effect)
		particle_count += 1
	else:
		particle_count -= 1