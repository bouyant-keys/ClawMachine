extends Node2D

var current_floor := 0

@export var level_list : LevelList
@export var current_level : int

@onready var level_container = $CurrentLevel as Node2D
@onready var game_manager: GameManager = $"../GameManager"

signal screen_wipe(Vector2)
signal update_camera(Vector2)

func _ready() -> void:
	load_level()

func update_camera_pos(to_floor:int, enter_dir:Vector2) ->void:
	if to_floor == current_floor: return
	game_manager.change_floor(to_floor, enter_dir)

# This script will load/swap certain tilesets, a 'main' set will stay with the 
# options menu and shop, but the 'depths' below level 0 will be loaded in. 
func load_level() ->void:
	for child : int in level_container.get_child_count():
		level_container.get_child(child).queue_free()
	
	if current_level < 0 or current_level > level_list.levels.size() - 1:
		current_level = 0
	
	var new_level = level_list.levels[current_level].instantiate() as Node
	level_container.add_child(new_level)

func on_win() ->void:
	current_level += 1
