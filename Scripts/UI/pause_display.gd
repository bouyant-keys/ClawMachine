extends Control

@onready var pause_panel: ColorRect = $PausePanel
@onready var pause_anim: AnimationPlayer = $PauseAnim

func on_pause() ->void:
	pause_panel.show()
	pause_anim.play("paused_anim")

func on_unpause() ->void:
	pause_panel.hide()
	pause_anim.stop()

#func hide_self() ->void: hide()
#func show_self() ->void: show()
