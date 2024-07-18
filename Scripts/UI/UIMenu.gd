extends Control

signal start_game


func on_start_pressed() ->void:
	emit_signal("start_game")

func hide_self() ->void: hide()
func show_self() ->void: show()
