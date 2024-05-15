extends Grabbable
class_name Grab_Block

@export var block_data : BlockData
@export_node_path() var rb_path

@onready var rb_obj = get_node(rb_path) as RigidBody2D

func on_grab() ->void:
	print("grabbing object")
	rb_obj.freeze = true
	hide()

func on_release() ->void:
	print("releasing object")
	rb_obj.freeze = false
	show()

func get_data() ->BlockData:
	return block_data

func get_sprite() ->Texture2D:
	return block_data.get_obj_sprite()
