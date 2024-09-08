extends Control

@onready var controller_bg: TextureRect = $ControllerBG
@onready var highlight: TextureRect = $ControllerBG/ControllerBar/GrabButton/Highlight
@onready var menu_buttons: Panel = $MenuButtons
@onready var special_button: TextureButton = $SpecialButton
@onready var button_sfx: AudioStreamPlayer = $ButtonClickSFX
@onready var special_sfx: AudioStreamPlayer = $SpecialClickSFX

signal v_speed_changed(dir:float)
signal h_speed_changed(dir:float)
signal grab_pressed
signal pause_pressed
signal reset_elements
signal stop_mouse_input(active:bool)
signal restart
signal back_to_menu
signal inc_palette

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
	
	if GameManager.instance.paused:
		menu_buttons.show()
	else:
		menu_buttons.hide()

func on_mainmenu_pressed() ->void:
	button_sfx.play()
	emit_signal("back_to_menu")

func on_restart_pressed() ->void:
	button_sfx.play()
	emit_signal("restart")

func on_special_pressed() ->void:
	special_sfx.play()
	emit_signal("inc_palette")

func reset() ->void:
	emit_signal("reset_elements")
	menu_buttons.hide()
	special_button.visible = GameManager.instance.game_completed_once

func hide_self() ->void: hide()
func show_self() ->void: show()
