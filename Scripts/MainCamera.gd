extends Camera2D

var start_pos := Vector2(80.0, 184.0)
var following := false

func _process(delta: float) -> void:
	if !following: return
	
	position.y = Player.position.y

func set_camera_follow(active:bool) ->void:
	following = active

func update_camera_pos(new_pos:Vector2) ->void:
	position = new_pos

func reset_camera() ->void:
	position = start_pos
