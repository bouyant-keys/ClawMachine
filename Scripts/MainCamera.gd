extends Camera2D

var start_pos := Vector2(80.0, 72.0)
var following := false

@export_node_path() var player_path

@onready var player : Player = get_node(player_path)
@onready var cam_anim: AnimationPlayer = $CamAnim

func _process(delta: float) -> void:
	if !following: return
	
	position.y = player.position.y

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("Transition"):
			camera_shake()

func set_camera_follow(active:bool) ->void:
	following = active
	print("Camera following: " + str(active))

func update_camera_pos(new_pos:Vector2) ->void:
	position = new_pos

func reset_camera() ->void:
	position = start_pos

func camera_shake() ->void:
	cam_anim.play("small_shake")
