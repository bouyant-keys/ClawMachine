extends Control

var top := true
var display_active := true

@onready var hud_menu: Control = $HUD
@onready var pause_menu: Control = $Pause
@onready var pause_anim: AnimationPlayer = $Pause/PauseAnimPlayer
@onready var grab_display = $HUD/GrabDisplay as TextureRect
@onready var top_bar: TextureRect = $HUD/TopBar
@onready var bottom_bar: TextureRect = $HUD/BottomBar


# Add Screen shake effect!!

func update_grab_display(new_text:String, set_display:bool) ->void:
	pass
	#grab_display.update_text(new_text, set_display)

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

func update_coins(value:int) ->void:
	top_bar.update_tickets(value)
	bottom_bar.update_tickets(value)

func on_pause() ->void:
	print("pausing")
	hud_menu.hide()
	pause_menu.show()
	pause_anim.play("paused_anim")

func on_unpause() ->void:
	print("unpausing")
	hud_menu.show()
	pause_menu.hide()
	pause_anim.stop()
