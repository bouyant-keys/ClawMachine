extends Control

var top := true
var display_active := true

var stopwatch_active := false
var start_time : float
var current_time : float
var pause_time_value := 0.0

@onready var hud_menu: Control = $HUD
@onready var pause_menu: Control = $Pause
@onready var pause_anim: AnimationPlayer = $Pause/PauseAnimPlayer
@onready var grab_display = $HUD/GrabDisplay as TextureRect
@onready var top_bar: TextureRect = $HUD/TopBar
@onready var bottom_bar: TextureRect = $HUD/BottomBar


# Add Screen shake effect!!

func _process(delta: float) -> void:
	if !stopwatch_active: return
	
	current_time = (Time.get_ticks_msec() - start_time) + pause_time_value
	top_bar.update_time(current_time)
	bottom_bar.update_time(current_time)

func swap_data_displays(set_top:bool) ->void:
	top = set_top
	
	top_bar.set_display(top and display_active)
	bottom_bar.set_display(!top and display_active)

func set_displaying(active:bool) ->void:
	display_active = active
	
	top_bar.set_display(top and display_active)
	bottom_bar.set_display(!top and display_active)

func update_health(value:float) ->void:
	top_bar.update_health(value)
	bottom_bar.update_health(value)

func update_tutorial(text:String) ->void:
	top_bar.update_tutorial(text)
	bottom_bar.update_tutorial(text)

func start_stopwatch() ->void:
	stopwatch_active = true
	start_time = Time.get_ticks_msec()

func stop_stopwatch() ->void:
	stopwatch_active = false

func on_pause() ->void:
	print("pausing")
	pause_menu.show()
	pause_anim.play("paused_anim")
	pause_time_value = current_time
	stopwatch_active = false

func on_unpause() ->void:
	print("unpausing")
	hud_menu.show()
	pause_menu.hide()
	start_stopwatch()

func reset() ->void:
	update_tutorial("Start (SPACE) ") #Default on reset value
	swap_data_displays(true)
	set_displaying(false)
	
	start_time = 0.0
	current_time = 0.0
	pause_time_value = 0.0
	top_bar.update_time(0.0)
	bottom_bar.update_time(0.0)
