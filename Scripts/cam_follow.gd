extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("camfollow entered")
	var player := body as Player
	player.set_cam_follow.emit(true)

func _on_body_exited(body: Node2D) -> void:
	print("camfollow exited")
	var player := body as Player
	player.set_cam_follow.emit(false)
