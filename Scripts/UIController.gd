extends Control

signal v_speed_changed(dir:float)
signal h_speed_changed(dir:float)
signal grab_pressed

func on_v_slider_changed(value:float) ->void:
	v_speed_changed.emit(value)

func on_h_slider_changed(value:float) ->void:
	h_speed_changed.emit(value)

func on_button_pressed() ->void:
	grab_pressed.emit()
