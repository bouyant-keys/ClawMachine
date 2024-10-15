extends Node
class_name GameManager

static var level_progress : Array[bool]
static var game_completed_once := false
static var deaths := 0
static var times_zapped := 0
static var total_time := 0 # value in miliseconds
static var instance : GameManager

var transitioning := false
var paused := false

@export var skip_main_menu := false
@export_node_path() var transition_path

@onready var win_sfx: AudioStreamPlayer = $WinSFX
@onready var lose_sfx: AudioStreamPlayer = $LoseSFX
@onready var transition: Transition_Shader = get_node(transition_path) as Transition_Shader

signal menu_process
signal game_process
signal reset_process
signal freeze_process(bool)
signal pause
signal unpause
signal music_change(menu:bool)
signal music_lower_vol
signal music_raise_vol
signal update_camera(Vector2)
signal display_controls

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_progress.resize(13)
	level_progress.fill(false)
	level_progress[0] = true # Allow first level to be accessible in level select
	
	# Singleton pattern:
	if instance == null:
		instance = self
	else:
		self.queue_free()
	
	if !skip_main_menu: call_deferred("menu", true)
	else: call_deferred("start")

func menu(firstTime:bool = false) ->void:
	if paused:
		set_pause()
	
	if !firstTime:
		emit_signal("music_change", true)
		emit_signal("freeze_process", true)
		transitioning = true
		await transition.fade_out(Vector2.ZERO)
	else:
		transitioning = true
	
	emit_signal("menu_process")
	
	await transition.fade_in(Vector2.ZERO)
	transitioning = false

func start(level:int = 0) ->void:
	MainLevel.current_level = level
	emit_signal("music_change", false)
	emit_signal("freeze_process", true)
	transitioning = true
	
	await transition.fade_out(Vector2.ZERO)
	emit_signal("game_process")
	emit_signal("reset_process")
	
	await transition.play_level_change(true, 0, MainLevel.current_level)
	
	await transition.fade_in(Vector2.ZERO)
	transitioning = false
	
	emit_signal("display_controls")
	
	await get_tree().create_timer(1.0).timeout
	emit_signal("freeze_process", false)

func win() ->void: # Called by CollectionBox
	if MainLevel.current_level < level_progress.size() - 1:
		level_progress[MainLevel.current_level+1] = true
	
	MainLevel.current_level += 1 # Mainlevel checks if value is out of bounds later
	
	emit_signal("freeze_process", true)
	transitioning = true
	win_sfx.play()
	await get_tree().create_timer(1.0).timeout # Hold on the win for a little
	
	await transition.fade_out(Vector2.ZERO)
	emit_signal("reset_process")
	emit_signal("music_lower_vol")
	
	await transition.play_level_change(false, MainLevel.current_level - 1, MainLevel.current_level) # CurrentLevel is now the next level, because it was incremented
	emit_signal("music_raise_vol")
	
	await transition.fade_in(Vector2.ZERO)
	transitioning = false
	
	emit_signal("display_controls")
	
	await get_tree().create_timer(1.0).timeout
	emit_signal("freeze_process", false)

func complete() ->void:
	game_completed_once = true
	level_progress[MainLevel.current_level] = true
	
	emit_signal("freeze_process", true)
	transitioning = true
	win_sfx.play()
	await get_tree().create_timer(1.0).timeout # Hold on the win for a little
	menu()

func lose() ->void:
	#print("lose")
	emit_signal("freeze_process", true)
	transitioning = true
	lose_sfx.play()
	await get_tree().create_timer(1.0).timeout # Hold on the lose for a little
	
	await transition.fade_out(Vector2.ZERO)
	emit_signal("reset_process")
	
	await transition.fade_in(Vector2.ZERO)
	transitioning = false
	emit_signal("freeze_process", false)

func restart_level() ->void:
	set_pause()
	start(MainLevel.current_level)

func set_pause() ->void:
	if paused:
		paused = false
		get_tree().paused = false
		emit_signal("unpause")
	else:
		paused = true
		get_tree().paused = true
		emit_signal("pause")
