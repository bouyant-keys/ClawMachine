extends Resource
class_name BlockData 
# For some reason above name isn't working, when it does
# this custom type hint should work

enum Object_Action {NONE, ITEM, COINS, WIN}

@export var obj_action : Object_Action
@export var obj_name : String
@export_node_path() var sprite_path
#@export_node_path() var level_path

func get_obj_action() ->Object_Action:
	return obj_action

func get_obj_name() ->String:
	return obj_name

func get_obj_sprite() ->Texture2D:
	return sprite_path

#func get_obj_level() ->NodePath:
	#return level_path
