extends Camera2D

var start_pos := Vector2(80.0, 72.0)

@export var following := true
@export_node_path() var player_path

@onready var player : Node2D = get_node(player_path)
#@onready var cam_anim: AnimationPlayer = $CamAnim

func _process(_delta: float) -> void:
	if !following: return
	
	position.y = player.position.y

func set_camera_follow(active:bool) ->void:
	following = active

func set_cam_limit(value:int) ->void:
	limit_bottom = value

func update_camera_pos(new_pos:Vector2) ->void:
	position = new_pos

func camera_shake() ->void:
	pass
	#cam_anim.play("small_shake")

func reset_camera() ->void:
	position = start_pos

func activate_camera() ->void:
	enabled = true

func deactivate_camera() ->void:
	enabled = false
