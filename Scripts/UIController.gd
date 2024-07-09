extends Control

@onready var controller_bg: TextureRect = $ControllerBG
@onready var anim: AnimationPlayer = $Controller_Anim

signal v_speed_changed(dir:float)
signal h_speed_changed(dir:float)
signal grab_pressed
signal pause_pressed

func display_controls() ->void:
	controller_bg.show()
	anim.play("RevealControls")

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
