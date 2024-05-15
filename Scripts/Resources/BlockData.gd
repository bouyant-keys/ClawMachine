extends Resource
class_name BlockData

enum Object_Action {NONE, ITEM, COINS, WIN}

@export var obj_action : Object_Action
@export var obj_name : String
@export_node_path() var sprite_path

func get_obj_action() ->Object_Action:
	return obj_action

func get_obj_name() ->String:
	return obj_name

#func get_obj_sprite() ->Texture2D:
	#var sprite := get_node(sprite_path) as Sprite2D
	#return sprite.texture
