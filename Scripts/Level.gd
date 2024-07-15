extends TileMap
class_name Level

@export_node_path() var goal_path
@export var cam_limit_y := 144.0

@onready var goal_obj = get_node(goal_path) as Node2D
