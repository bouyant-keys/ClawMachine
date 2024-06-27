extends Node2D
class_name MainLevel

static var current_level := 0
var current_floor := 0

@export_node_path() var gm_path
@export var level_list : LevelList
@export var start_level : int

@onready var level_container = $CurrentLevel as Node2D
@onready var game_manager: GameManager = get_node(gm_path)
@onready var down_arrows: AnimatedSprite2D = $DownArrows
@onready var up_arrows: AnimatedSprite2D = $UpArrows

signal screen_wipe(Vector2)
signal update_camera(Vector2)
#signal new_level(int)

func _ready() -> void:
	current_level = start_level
	load_level()
	down_arrows.play("default")
	up_arrows.play("default")

func update_camera_pos(to_floor:int, enter_dir:Vector2) ->void:
	if to_floor == current_floor: return
	
	current_floor = to_floor
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
	#emit_signal("new_level", current_level)

func on_win() ->void:
	current_level += 1
