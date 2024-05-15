extends ColorRect
class_name Transition_Shader

var dir : Vector2

@export var wipe_time := 1.5
@export var hold_time := 1.0

@onready var start_label = $Label as Label

signal start_transition
signal end_transition


func _ready() -> void:
	show()
	#start_label.show()
	material.set_shader_parameter("progress", 1.0)

func fade_out(new_dir:Vector2) ->void:
	show()
	var mult = 0.0
	dir = new_dir
	material.set_shader_parameter("direction", dir)
	
	if dir.x < 0.0 or dir.y < 0.0: mult = -0.5
	material.set_shader_parameter("mult", mult)
	
	var wipe_tween = get_tree().create_tween()
	wipe_tween.tween_method(update_shader_progress, 0.0, 1.0, wipe_time)
	
	await wipe_tween.finished

func fade_in(new_dir:Vector2) ->void:
	var mult = 0.0
	dir = new_dir
	material.set_shader_parameter("direction", dir)
	
	if dir.x < 0.0 or dir.y < 0.0: mult = -0.5
	material.set_shader_parameter("mult", mult)
	
	var wipe_tween = get_tree().create_tween()
	wipe_tween.tween_method(update_shader_progress, 1.0, 0.0, wipe_time)
	
	await wipe_tween.finished
	hide()

func update_shader_progress(value:float) ->void:
	material.set_shader_parameter("progress", value)
