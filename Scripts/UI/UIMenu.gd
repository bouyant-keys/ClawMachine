extends Control

signal start_game(int)
signal level_select

@onready var claw: MenuClaw = $Claw
@onready var start_button_container: VBoxContainer = $StartButtonContainer
@onready var level_button_container: HFlowContainer = $LevelButtonContainer
@onready var stop_mouse_panel: Panel = $StopMouseInput

func _ready() -> void:
	stop_mouse_panel.show()
	start_button_container.show()
	level_button_container.hide()

func on_menu_load() ->void:
	await claw.menu_start()
	stop_mouse_panel.hide()

func on_start_pressed() ->void:
	await claw.start_button_pressed()
	emit_signal("start_game", 0)

func on_level_select_pressed() ->void:
	await claw.lvl_select_button_pressed()
	
	start_button_container.hide()
	level_button_container.show()

func on_level_pressed(value:int) ->void:
	await claw.level_button_pressed(value)
	emit_signal("start_game", value)


func hide_self() ->void: hide()
func show_self() ->void: show()
