extends Resource
class_name TransitionData

enum Room {LEVELS, OPTIONS, SHOP}

@export var to_room : Room
@export var to_level := 0 # 0 = top floor
@export var enter_directon : Vector2

# Convert enum to Vector2 value
func get_room_position() ->Vector2:
	var new_pos := Vector2.ZERO
	match to_room:
		Room.OPTIONS:
			new_pos = Vector2(-80.0, 72.0)
		Room.SHOP:
			new_pos = Vector2(240.0, 72.0)
		Room.LEVELS:
			var temp := 72.0 + (144.0 * to_level)
			new_pos = Vector2(80.0, temp)
	return new_pos
