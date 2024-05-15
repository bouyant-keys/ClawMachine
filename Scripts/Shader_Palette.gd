extends ColorRect

var current_pattern = 0

func _ready():
	show()
	change_palette(0)

func change_palette(value:int):
	var new_index = current_pattern + value
	if (new_index > 15): new_index = 0
	elif (new_index < 0): new_index = 15
	
	current_pattern = new_index
	print("Pattern Index: " + str(current_pattern))
	material.set_shader_parameter("palette_index", current_pattern)
