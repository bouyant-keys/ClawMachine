extends RigidBody2D

@onready var gb_obj = $Area2D as Grab_Block

func get_block() ->Grab_Block:
	return gb_obj
