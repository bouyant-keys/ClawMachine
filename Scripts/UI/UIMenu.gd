extends Control

signal start_game(int)
signal level_select

@onready var claw: MenuClaw = $Claw

func on_start_pressed() ->void:
	await claw.start_button_pressed()
	emit_signal("start_game", 0)

func on_level_select_pressed() ->void:
	await claw.level_button_pressed()
	emit_signal("level_select")

func on_level_pressed(value:int) ->void:
	await claw.level_button_pressed()
	emit_signal("start_game", value)


func hide_self() ->void: hide()
func show_self() ->void: show()
