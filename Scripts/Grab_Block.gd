extends RigidBody2D
class_name Grab_Block

@export var block_data : BlockData

@onready var sprite: Sprite2D = $Sprite2D

func on_grab() ->void:
	print("grabbing object")
	freeze = true
	hide()

func on_release() ->void:
	print("releasing object")
	freeze = false
	show()

func get_data() ->BlockData:
	return block_data

func get_sprite() ->Texture2D:
	return sprite.texture
