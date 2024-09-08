extends Node2D
class_name MainLevel

static var current_level := -1

@export var level_list : LevelList
@export var skip_to_lvl := false
@export var start_level : int

signal set_cam_limit(int)
signal goal_position(capsule:Node2D, box:Node2D)
signal game_complete


func load_level() ->void:
	if skip_to_lvl:
		current_level = start_level
		skip_to_lvl = false
	
	for child : int in self.get_child_count():
		self.get_child(child).queue_free()
	
	var new_level : Level
	if current_level < 0: 
		current_level = 0
	elif current_level > level_list.levels.size() - 1: 
		current_level = 0
	
	new_level = level_list.levels[current_level].instantiate() as Level
	self.add_child(new_level)
	
	emit_signal("goal_position", new_level.goal_obj, new_level.collection_obj)
	emit_signal("set_cam_limit", int(new_level.cam_limit_y))

func load_menu() ->void:
	#print("loading menu")
	for child : int in self.get_child_count():
		self.get_child(child).queue_free()
	
	var new_level := preload("res://Scenes/Levels/menu_level.tscn").instantiate() as LevelMenu
	new_level.play_menu()
	self.add_child(new_level)
