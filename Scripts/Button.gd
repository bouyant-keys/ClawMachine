extends Node2D

var is_pressed := false

@onready var anim: AnimationPlayer = $AnimationPlayer

signal on_press
signal on_release

func press_button(active:bool) ->void:
	if is_pressed == active: return
	
	is_pressed = active
	if active:
		anim.play("Pressing")
		on_press.emit()
	else:
		anim.play("Releasing")
		on_release.emit()

func on_area_entered(area:Area2D) ->void:
	press_button(true)

func on_area_exited(area:Area2D) ->void:
	press_button(false)
