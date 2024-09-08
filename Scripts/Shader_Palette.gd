extends ColorRect

@export var current_pattern = 0

func _ready():
	show()
	change_palette(0)

#func _input(event: InputEvent) -> void:
	##if !GameManager.game_completed_once: return
	#
	#if event is InputEventKey:
		#if event.is_action_pressed("Inc_Palette"): change_palette(1)
		#elif event.is_action_pressed("Dec_Palette"): change_palette(-1)

func increment_palette() ->void:
	change_palette(1)

func change_palette(value:int):
	var new_index = current_pattern + value
	if (new_index > 15): new_index = 0
	elif (new_index < 0): new_index = 15
	
	current_pattern = new_index
	print("Pattern Index: " + str(current_pattern))
	material.set_shader_parameter("palette_index", current_pattern)
