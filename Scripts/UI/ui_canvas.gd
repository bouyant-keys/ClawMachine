extends Control

var top := true
var display_active := true

var stopwatch_active := false
var start_time : float
var current_time : float
var pause_time_value := 0.0

@onready var hud_menu: Control = $HUD
@onready var grab_display = $HUD/GrabDisplay as TextureRect
@onready var top_bar: TextureRect = $HUD/TopBar
@onready var bottom_bar: TextureRect = $HUD/BottomBar
@onready var hud_anim: AnimationPlayer = $HUD/HUDAnim
@onready var t_arrows: TextureRect = $HUD/TopArrows
@onready var b_arrows: TextureRect = $HUD/BottomArrows
@onready var pause_menu: Control = $Pause
@onready var pause_anim: AnimationPlayer = $Pause/PauseAnim


# Add Screen shake effect!!

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

func update_depth(value:float) ->void:
	var temp : int = roundi(value / 20.0)
	top_bar.update_health(temp)
	bottom_bar.update_health(temp)

func update_tutorial(text:String) ->void:
	top_bar.update_tutorial(text)
	bottom_bar.update_tutorial(text)

func enable_arrows(top_arrows:bool) ->void:
	if top_arrows: 
		t_arrows.show()
		b_arrows.hide()
	else:
		t_arrows.hide()
		b_arrows.show()
	
	hud_anim.play("ArrowBlink")

func disable_arrows() ->void:
	if hud_anim.is_playing(): hud_anim.stop()
	
	t_arrows.hide()
	b_arrows.hide()

func on_pause() ->void:
	print("pausing")
	pause_menu.show()
	pause_anim.play("paused_anim")

func on_unpause() ->void:
	print("unpausing")
	hud_menu.show()
	pause_menu.hide()

func reset() ->void:
	swap_data_displays(true)
	set_displaying(false)


func on_start_tut_timer_timeout() -> void:
	top = true
	set_displaying(true)
	update_tutorial("Start (SPACE) ")
