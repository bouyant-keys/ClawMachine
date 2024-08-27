extends Control

@onready var pause_panel: ColorRect = $PausePanel
@onready var pause_anim: AnimationPlayer = $PauseAnim

signal back_to_menu

func _ready() -> void:
	hide()

func on_mainmenu_pressed() ->void:
	emit_signal("back_to_menu")

func on_pause() ->void:
	show()
	pause_anim.play("paused_anim")

func on_unpause() ->void:
	hide()
	pause_anim.stop()

#func hide_self() ->void: hide()
#func show_self() ->void: show()
