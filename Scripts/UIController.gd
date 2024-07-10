extends Control

@onready var controller_bg: TextureRect = $ControllerBG

signal v_speed_changed(dir:float)
signal h_speed_changed(dir:float)
signal grab_pressed
signal pause_pressed

func _ready() -> void:
	controller_bg.hide()

func display_controls(hide:bool) ->void:
	if !hide:
		controller_bg.show()
	else:
		controller_bg.hide()

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
