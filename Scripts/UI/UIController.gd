extends Control

@onready var controller_bg: TextureRect = $ControllerBG
@onready var highlight: TextureRect = $ControllerBG/ControllerBar/GrabButton/Highlight

signal v_speed_changed(dir:float)
signal h_speed_changed(dir:float)
signal grab_pressed
signal pause_pressed
signal reset_elements
signal stop_mouse_input(active:bool)

#func _ready() -> void:
	#controller_bg.hide()

# In-game functions:

func freeze_controls(freeze:bool) ->void:
	emit_signal("stop_mouse_input", freeze)

func highlight_grab(active:bool) ->void:
	highlight.visible = active
	#print("highlighting grab button")

func on_v_slider_changed(value:float) ->void:
	v_speed_changed.emit(value)

func on_h_slider_changed(value:float) ->void:
	h_speed_changed.emit(value)

func on_grab_pressed() ->void:
	grab_pressed.emit()
	
	if highlight.visible:
		highlight.hide()

func on_pause_pressed() ->void:
	pause_pressed.emit()

func reset() ->void:
	emit_signal("reset_elements")

func hide_self() ->void: hide()
func show_self() ->void: show()
