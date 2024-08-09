extends RigidBody2D
class_name Grab_Block

@export var block_data : BlockData

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var arrow_sprite: Sprite2D = $ArrowSprite

func on_grab() ->void:
	print("grabbing object: " + name)
	freeze = true
	area.hide()
	arrow_sprite.hide()
	hide()

func on_release() ->void:
	print("releasing object: " + name)
	freeze = false
	area.show()
	show()

func get_data() ->BlockData:
	return block_data

func get_sprite() ->Texture2D:
	return sprite.texture
