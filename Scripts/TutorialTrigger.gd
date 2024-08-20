extends Area2D

@export var tutorial_text : String

#func on_body_entered(body:Node2D) ->void:
	#if body is Player: 
		#body.update_tutorial.emit(tutorial_text)
		##queue_free()

#func on_body_exited(body:Node2D) ->void:
	#if body is Player: 
		#body.update_tutorial.emit("............................... ")
		##queue_free()
