extends Node2D
class_name MenuClaw

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func start_anim() ->void:
	anim_player.play("StartAnim")
	
	await anim_player.animation_finished
	anim_player.play("IdleLoop")


func start_button_selected() ->void:
	anim_player.pause()
	

func start_button_pressed() ->void:
	pass


func level_button_selected() ->void:
	pass

func level_button_pressed() ->void:
	pass
