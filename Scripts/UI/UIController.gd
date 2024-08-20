extends Control

@export_node_path() var stop_input_path

@onready var controller_bg: TextureRect = $ControllerBG
@onready var highlight: TextureRect = $ControllerBG/ControllerBar/GrabButton/Highlight
@onready var stop_mouse_panel: Panel = get_node(stop_input_path) as Panel

signal v_speed_changed(dir:float)
signal h_speed_changed(dir:float)
signal grab_pressed
signal pause_pressed
signal reset_knob

#func _ready() -> void:
	#controller_bg.hide()

# In-game functions:

func freeze_controls(freeze:bool) ->void:
	if freeze:
		stop_mouse_panel.show()
	else:
		stop_mouse_panel.hide()

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
	emit_signal("reset_knob")

func hide_self() ->void: hide()
func show_self() ->void: show()
