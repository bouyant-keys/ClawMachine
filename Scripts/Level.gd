extends TileMap
class_name Level

@export var is_menu := false
@export_node_path() var goal_path
#@export_node_path() var box_path
@export var cam_limit_y := 144.0

@onready var goal_obj = get_node(goal_path) as Node2D
#@onready var collect_obj = get_node(box_path) as Node2D
@onready var collection_obj: Node2D = $CollectionBox
