extends OptionButton

var resolution_x = [1024, 1600, 1920]
var resolution_y = [720, 900, 1080]
var current_resolution = Vector2(0, 0)
var previous_res_index 
var current_res_index
var Settings_Panel = get_parent()

func change_resolution(idx):
	set_res_var(idx)
	print("The current resolution is: " + str(current_resolution))
	OS.set_window_size(current_resolution)

func get_res_var():
	return current_resolution

func set_res_var(index):
	current_resolution = Vector2(resolution_x[index], resolution_y[index])

# checks the resolution to see if it needs to be changed relative to the
# dropdown selection by player
func check_resolution():
	# gets current selected resolution id from drop-down list
	current_res_index = get_item_id(get_selected_id())
	
	# if the current selected resolution does not equal the default resolution,
	# then we need to branch some logic
	if(current_res_index == previous_res_index):
		return
	else:
		# change the resolution and pass the selected resolution index variable away
		change_resolution(current_res_index)
		# check if the selection is okay
		get_node("ConfirmationDialog").show()
		get_tree().paused = true

func _ready():
	add_item("1024x720",0)
	add_item("1600x900",1)
	add_item("1920x1080",2)
	
	select(0)
	previous_res_index = get_item_id(get_selected_id())
	current_res_index = get_item_id(get_selected_id())
	change_resolution(current_res_index)

func _process(delta):
	if(is_visible_in_tree()):
		check_resolution()