extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

#func _input(event: InputEvent) -> void:
	#if event is InputEventAction:
		#if event.is_action_pressed("Grab"):
			#print(visible)

func set_visibility(visible:bool) ->void:
	self.visible = visible
	print("StopMousePanel visible: " + str(self.visible))
