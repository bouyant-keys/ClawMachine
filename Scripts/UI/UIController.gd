extends Control

@onready var controller_bg: TextureRect = $ControllerBG
@onready var highlight: TextureRect = $ControllerBG/ControllerBar/GrabButton/Highlight

signal v_speed_changed(dir:float)
signal h_speed_changed(dir:float)
signal grab_pressed
signal pause_pressed
signal reset_knob

func _ready() -> void:
	controller_bg.hide()

# In-game functions:

func display_controls(set_hide:bool) ->void:
	if !set_hide:
		controller_bg.show()
	else:
		controller_bg.hide()

func highlight_grab(active:bool) ->void:
	highlight.visible = active

func on_v_slider_changed(value:float) ->void:
	v_speed_changed.emit(value)

func on_h_slider_changed(value:float) ->void:
	h_speed_changed.emit(value)

func on_grab_pressed() ->void:
	grab_pressed.emit()

func on_pause_pressed() ->void:
	pause_pressed.emit()

func reset() ->void:
	controller_bg.hide()
	emit_signal("reset_knob")

func hide_self() ->void: hide()
func show_self() ->void: show()
