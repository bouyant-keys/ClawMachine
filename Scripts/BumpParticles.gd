extends GPUParticles2D


func on_bump(pos:Vector2) ->void:
	position = pos
	emitting = true
