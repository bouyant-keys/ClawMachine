extends Node
class_name GameManager

@onready var transition: ColorRect = $"../CanvasLayer/TransitionShader"

signal start_process
signal win_process
signal lose_process
signal reset_process
signal pause
signal update_camera(Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("intro")

func intro() ->void:
	await transition.fade_in(Vector2.ZERO)
	emit_signal("start_process")

func win() ->void:
	emit_signal("win_process")
	
	await transition.fade_out(Vector2.ZERO)
	emit_signal("reset_process")
	
	await transition.fade_in(Vector2.ZERO)
	emit_signal("start_process")

func lose() ->void:
	emit_signal("lose_process")
	
	await transition.fade_out(Vector2.ZERO)
	emit_signal("reset_process")
	
	await transition.fade_in(Vector2.ZERO)
	emit_signal("start_process")

func change_floor(floor:int, dir:Vector2) ->void:
	Player.input_enabled = false
	
	await transition.fade_out(dir)
	emit_signal("update_camera", Vector2(80.0, 72.0 + (144.0 * floor)))
	
	await transition.fade_in(dir)
	Player.input_enabled = true

#func pause() ->void:
	#pass