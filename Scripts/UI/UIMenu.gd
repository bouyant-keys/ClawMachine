extends Control

const disabledColor: Color = Color8(64, 64, 64)

@export_node_path() var stop_input_path

@onready var claw: MenuClaw = $Claw
@onready var start_button_container: VBoxContainer = $StartButtonContainer
@onready var level_button_container: HFlowContainer = $LevelButtonContainer
@onready var stop_mouse_panel: Panel = get_node(stop_input_path) as Panel
@onready var press_sfx: AudioStreamPlayer = $ButtonClickSFX
@onready var special_button: TextureButton = $SpecialButton
@onready var special_sfx: AudioStreamPlayer = $SpecialClickSFX

signal start_game(int)
signal disable_start
signal disable_select
signal disable_levels(except:int)
signal enable_all
signal level_select
signal stop_mouse_input(active:bool)
signal inc_palette


func _ready() -> void:
	level_button_container.self_modulate = Color.WHITE
	start_button_container.show()
	level_button_container.hide()

func on_menu_load() ->void:
	special_button.visible = GameManager.instance.game_completed_once
	emit_signal("enable_all")
	emit_signal("stop_mouse_input", true)
	await claw.menu_start()
	emit_signal("stop_mouse_input", false)

func on_start_pressed() ->void:
	press_sfx.play()
	emit_signal("stop_mouse_input", true)
	emit_signal("disable_select")
	await claw.start_button_pressed()
	emit_signal("start_game", 0)

func on_level_select_pressed() ->void:
	press_sfx.play()
	emit_signal("stop_mouse_input", true)
	emit_signal("disable_start")
	await claw.lvl_select_button_pressed()
	
	start_button_container.hide()
	level_button_container.show()
	await claw.menu_start()
	
	emit_signal("stop_mouse_input", false) # Needed here so that player can click on level buttons

func on_level_pressed(index:int) ->void:
	press_sfx.play()
	emit_signal("stop_mouse_input", true)
	emit_signal("disable_levels", index)
	await claw.level_button_pressed(index)
	emit_signal("start_game", index)

func on_special_press() ->void:
	special_sfx.play()
	emit_signal("inc_palette")

func hide_self() ->void: hide()
func show_self() ->void: show()
