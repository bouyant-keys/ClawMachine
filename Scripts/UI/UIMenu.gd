extends Control

const disabledColor: Color = Color8(64, 64, 64)

@export_node_path() var stop_input_path

@onready var claw: MenuClaw = $Claw
@onready var start_button_container: VBoxContainer = $StartButtonContainer
@onready var level_button_container: HFlowContainer = $LevelButtonContainer
@onready var stop_mouse_panel: Panel = get_node(stop_input_path) as Panel

signal start_game(int)
signal disable_start
signal disable_select
signal disable_levels(except:int)
signal enable_all
signal level_select


func _ready() -> void:
	#start_panel.self_modulate = Color.WHITE
	#select_panel.self_modulate = Color.WHITE
	level_button_container.self_modulate = Color.WHITE
	stop_mouse_panel.show()
	start_button_container.show()
	level_button_container.hide()

func on_menu_load() ->void:
	stop_mouse_panel.show()
	await claw.menu_start()
	stop_mouse_panel.hide()

func on_start_pressed() ->void:
	stop_mouse_panel.show()
	emit_signal("disable_select")
	await claw.start_button_pressed()
	emit_signal("start_game", 0)

func on_level_select_pressed() ->void:
	stop_mouse_panel.show()
	emit_signal("disable_start")
	await claw.lvl_select_button_pressed()
	
	start_button_container.hide()
	level_button_container.show()
	await claw.menu_start()
	
	stop_mouse_panel.hide()

func on_level_pressed(index:int) ->void:
	stop_mouse_panel.show()
	emit_signal("disable_levels", index)
	await claw.level_button_pressed(index)
	emit_signal("start_game", index)


func hide_self() ->void: hide()
func show_self() ->void: show()
