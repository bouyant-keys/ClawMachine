extends Node2D
class_name LevelMenu

var cam_scroll_speed := 40.0
var menu_anim : AnimationPlayer

@onready var menu_camera: Camera2D = $MenuCamera

#@onready var menu_cam_anim: AnimationPlayer = $MenuCamAnim

func play_menu() ->void:
	#await menu_cam_anim.ready
	#menu_anim = $MenuCamAnim as AnimationPlayer
	#menu_anim.play("menu_loop")
	set_process(true)

func _process(delta: float) -> void:
	menu_camera.position.y += cam_scroll_speed * delta
