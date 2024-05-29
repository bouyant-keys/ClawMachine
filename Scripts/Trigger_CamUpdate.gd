extends Area2D

@export var to_floor : int
@export var enter_direction : Vector2i

signal change_floor(to_floor:int, enter_direction:Vector2)

func on_area_entered(body:Node2D) ->void:
	#print("player detected")
	emit_signal("change_floor", to_floor, enter_direction)
