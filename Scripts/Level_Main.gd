extends Node2D
class_name MainLevel

static var current_level := 0
var current_floor := 0

@export_node_path() var gm_path
@export var level_list : LevelList
@export var start_level : int
@export var test_lvl := false

@onready var game_manager: GameManager = get_node(gm_path)

#signal menu()
#signal level_win()
#signal screen_wipe(Vector2)
signal set_cam_limit(int)
signal goal_position(capsule:Node2D, box:Node2D)

func _ready() -> void:
	current_level = start_level
	#call_deferred("load_level")

#func on_goal_collected() ->void:
	#emit_signal("level_win")

func load_level() ->void:
	#TODO Comment following block out in final build
	if current_level == 0:
		current_level = start_level
	
	for child : int in self.get_child_count():
		self.get_child(child).queue_free()
	
	var new_level : Level
	if test_lvl:
		new_level = preload("res://Scenes/Levels/test_level.tscn").instantiate() as Level
		self.add_child(new_level)
	else:
		if current_level < 0: 
			current_level = 0
		elif current_level > level_list.levels.size() - 1: 
			#emit_signal("menu")
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
