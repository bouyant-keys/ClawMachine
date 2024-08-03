extends Node
class_name GameManager

static var game_completed_once := false
static var deaths := 0
static var times_zapped := 0
static var total_time := 0 # value in miliseconds
static var instance : GameManager

var transitioning := false
var paused := false

#@onready var main_level: MainLevel = $"../MainLevel"
@onready var transition: Transition_Shader = $"../CanvasLayer/TransitionShader"

signal menu_process
signal game_process
signal reset_process
signal freeze_process(bool)
signal pause
signal unpause
signal update_camera(Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if instance == null:
		instance = self
	else:
		self.queue_free()
	
	call_deferred("menu")

#func _input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if event.is_action_pressed("Pause") && !transitioning: set_pause()

func menu() ->void:
	#emit_signal("freeze_process", true)
	emit_signal("menu_process")
	transitioning = true
	
	await transition.fade_in(Vector2.ZERO)
	transitioning = false
	#emit_signal("freeze_process", false)

func start(level:int = 0) ->void:
	print("starting")
	MainLevel.current_level = level
	emit_signal("freeze_process", true)
	transitioning = true
	
	await transition.fade_out(Vector2.ZERO)
	emit_signal("game_process")
	emit_signal("reset_process")
	
	await transition.fade_in(Vector2.ZERO)
	transitioning = false
	emit_signal("freeze_process", false)

func win() ->void:
	print("win")
	MainLevel.current_level += 1
	emit_signal("freeze_process", true)
	transitioning = true
	
	await transition.fade_out(Vector2.ZERO)
	emit_signal("reset_process")
	
	await transition.play_level_change()
	
	await transition.fade_in(Vector2.ZERO)
	transitioning = false
	emit_signal("freeze_process", false)

func lose() ->void:
	print("lose")
	emit_signal("freeze_process", true)
	transitioning = true
	
	await transition.fade_out(Vector2.ZERO)
	emit_signal("reset_process")
	
	await transition.fade_in(Vector2.ZERO)
	transitioning = false
	emit_signal("freeze_process", false)

#func change_floor(new_floor:int, dir:Vector2) ->void:
	#emit_signal("freeze_process", true)
	#transitioning = true
	#
	#await transition.fade_out(dir)
	#emit_signal("update_camera", Vector2(80.0, 72.0 + (144.0 * new_floor)))
	#
	#await transition.fade_in(dir)
	#emit_signal("freeze_process", false)
	#transitioning = false

func set_pause() ->void:
	if paused:
		paused = false
		get_tree().paused = false
		emit_signal("unpause")
	else:
		paused = true
		get_tree().paused = true
		emit_signal("pause")
