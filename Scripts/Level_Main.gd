extends Node2D
class_name MainLevel

static var current_level := 0
var current_floor := 0

@export_node_path() var gm_path
@export var level_list : LevelList
@export var start_level : int
@export var test_lvl := false

@onready var game_manager: GameManager = get_node(gm_path)

signal screen_wipe(Vector2)
signal update_camera(Vector2)
signal goal_position(Node2D)

func _ready() -> void:
	current_level = start_level
	load_level()
	#down_arrows.play("default")
	#up_arrows.play("default")

func update_camera_pos(to_floor:int, enter_dir:Vector2) ->void:
	if to_floor == current_floor: return
	
	current_floor = to_floor
	game_manager.change_floor(to_floor, enter_dir)

# This script will load/swap certain tilesets, a 'main' set will stay with the 
# options menu and shop, but the 'depths' below level 0 will be loaded in. 
func load_level() ->void:
	for child : int in self.get_child_count():
		self.get_child(child).queue_free()
	
	var new_level : Node
	
	if test_lvl:
		new_level = preload("res://Scenes/Levels/test_level.tscn").instantiate() as Node
		self.add_child(new_level)
		#triggers.hide()
	else:
		if current_level < 0 or current_level > level_list.levels.size() - 1:
			current_level = 0
		
		new_level = level_list.levels[current_level].instantiate() as Node
		self.add_child(new_level)
		#triggers.show()
	
	for child : int in new_level.get_child_count():
		var current_child := new_level.get_child(child)
		if current_child.get_groups().size() == 0: continue
		
		for group in current_child.get_groups():
			if group != "Goal": continue
			goal_position.emit(current_child)
	#emit_signal("new_level", current_level)

#func on_win() ->void:
	#current_level += 1
