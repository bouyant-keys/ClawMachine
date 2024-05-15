extends Grabbable
class_name Grab_Slider

var updating := false

var move_range := Vector2(-16.0, 16.0)
var claw_y := -8.0

@export_range(0.0, 1.0) var value : float
@export var min_value : float
@export var max_value : float

@onready var knob_sprite = $"../SliderKnob" as Sprite2D

signal value_changed(float)


func on_grab() ->void:
	print("grabbing object")

func on_release() ->void:
	print("releasing object")
	emit_signal("value_changed", value)

func get_restrictions() ->Vector3:
	return Vector3(move_range.x, move_range.y, claw_y)

func update_value(new_value:float) ->void:
	var value_range = move_range.y - move_range.x
	var normalized_value = (new_value - move_range.x) / (move_range.y - move_range.x)
	print(normalized_value)
	value = (normalized_value * value_range) - move_range.y
	emit_signal("value_changed", value)

func get_sprite() ->Texture2D:
	return knob_sprite.texture
