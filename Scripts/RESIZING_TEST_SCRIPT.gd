extends Panel

var VIEWPORT_BOUND = Vector2(0,0)
const VIEWPORT_MARGIN = Vector2(24,24)

func set_bottom_margin(control, value, bounded = false):
	
	if(control != null):
		
		var tempSize = control.get_size()
		
		if(!bounded):
			tempSize.y = value
			control.set_size(tempSize)
			return
		else:
			if(value >= (VIEWPORT_BOUND.y - (2*VIEWPORT_MARGIN.y)) ):
				value = VIEWPORT_BOUND.y - (2*VIEWPORT_MARGIN.y)
				tempSize.y = value
				control.set_size(tempSize)
			else:
				tempSize.y = value
				control.set_size(tempSize)
			return
	else:
		print("\n@@@@@~URGENT~@@@@@\tCONTROL NODE DOES NOT EXIST ON SET_MARGIN CALL!\n")
		return

func set_right_margin(control, value, bounded = false):
	
	if(control != null):
		
		var tempSize = control.get_size()
		
		if(!bounded):
			tempSize.x = value
			control.set_size(tempSize)
			return
		else:
			if(value >= (VIEWPORT_BOUND.x - (2 * VIEWPORT_MARGIN.x))):
				value = VIEWPORT_BOUND.x - (2 * VIEWPORT_MARGIN.x)
				tempSize.x = value
				control.set_size(tempSize)
			else:
				tempSize.x = value
				control.set_size(tempSize)
			return
	else:
		print("\n@@@@@~URGENT~@@@@@\tCONTROL NODE DOES NOT EXIST ON SET_MARGIN CALL!\n")
		return

func set_top_margin(control, value, bounded = false):
	
	if(control != null):
		
		var tempSize = control.get_size()
		var tempPos = control.get_global_position()
		
		if(!bounded):
			tempPos.y -= value
			tempSize.y += value
			control.set_size(tempSize)
			control.set_global_position(tempPos)
			return
		else:
			tempSize.y += control.get_margin(MARGIN_TOP)
			tempPos.y = VIEWPORT_MARGIN.y
			control.set_global_position(tempPos)
			control.set_size(tempSize)
			return
	else:
		print("\n@@@@@~URGENT~@@@@@\tCONTROL NODE DOES NOT EXIST ON SET_MARGIN CALL!\n")
		return

func set_left_margin(control, value, bounded = false):
	
	if(control != null):
		
		var tempSize = control.get_size()
		var tempPos = control.get_global_position()
		
		if(!bounded):
			tempPos.x -= value
			tempSize.x += value
			control.set_size(tempSize)
			control.set_global_position(tempPos)
			return
		else:
			tempSize.x += control.get_margin(MARGIN_LEFT)
			tempPos.x = VIEWPORT_MARGIN.x
			control.set_global_position(tempPos)
			control.set_size(tempSize)
			return
	else:
		print("\n@@@@@~URGENT~@@@@@\tCONTROL NODE DOES NOT EXIST ON SET_MARGIN CALL!\n")
		return

func set_size_margin(control, value, bounded = false):
	
	if(control != null):
		print("NOT NULL")
		if(!bounded):
			print("NOT-BOUNDED. VALUE := ",value)
			set_right_margin(control, value.x)
			set_bottom_margin(control, value.y)
			return
		else:
			print("BOUNDED. VALUE := ",value)
			set_right_margin(control, value.x, true)
			set_bottom_margin(control, value.y, true)
			left_justify(control, true)
			return
	else:
		print("\n@@@@@~URGENT~@@@@@\tCONTROL NODE DOES NOT EXIST ON SET_SIZE_MARGIN CALL!\n")
		return

func get_center_of_control(control):
	var centerPos = Vector2(0,0)
	
	centerPos.x = (control.get_size().x * 0.5)
	centerPos.y = (control.get_size().y * 0.5)
	
	return centerPos

func left_justify(control, bounded = false):
	
	if(!bounded):
		control.set_global_position(VIEWPORT_BOUND)
		return
	else:
		control.set_global_position(VIEWPORT_MARGIN)
		return

func right_justify(control, bounded = false):
	
	var tempPos = Vector2(0,0)
	
	if(!bounded):
		tempPos.x = VIEWPORT_BOUND.x - control.get_size().x
		control.set_global_position(tempPos)
		return
	else:
		tempPos.x = (VIEWPORT_BOUND.x - control.get_size().x) - VIEWPORT_MARGIN.x
		tempPos.y = VIEWPORT_MARGIN.y
		control.set_global_position(tempPos)
		return

func center_justify(control, bounded = false):
	
	var centerPos = Vector2(0,0)
	centerPos.x = (VIEWPORT_BOUND.x * 0.5) - (control.get_size().x * 0.5)
	
	if(!bounded):
		control.set_global_position(centerPos)
		return
	else:
		centerPos.y = VIEWPORT_MARGIN.y
		control.set_global_position(centerPos)
		return

func warp_center_of_screen(control):
	
	var tempPos = Vector2(0,0)
	tempPos.x = (VIEWPORT_BOUND.x * 0.5) - (control.get_size().x * 0.5) 
	tempPos.y = (VIEWPORT_BOUND.y * 0.5) - (control.get_size().y * 0.5)
	
	control.set_global_position(tempPos)
