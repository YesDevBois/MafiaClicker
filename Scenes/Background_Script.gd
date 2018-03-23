extends TextureRect

func _ready():
	set_expand(true)
	set_size(get_viewport().get_size())


func _on_ResolutionButton_resolution_changed(current_resolution,idx):
	set_size(current_resolution)
