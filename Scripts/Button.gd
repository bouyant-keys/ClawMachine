extends Node2D

var is_pressed := false

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var press_sfx: AudioStreamPlayer = $Press_SFX
@onready var release_sfx: AudioStreamPlayer = $Release_SFX

signal on_press
signal on_release

func press_button(active:bool) ->void:
	if is_pressed == active: return
	
	is_pressed = active
	if active:
		anim.play("Pressing")
		press_sfx.play()
		on_press.emit()
	else:
		anim.play("Releasing")
		release_sfx.play()
		on_release.emit()

func on_area_entered(_area:Area2D) ->void:
	press_button(true)

func on_area_exited(_area:Area2D) ->void:
	press_button(false)
