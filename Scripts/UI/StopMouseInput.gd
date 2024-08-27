extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func set_visibility(visible:bool) ->void:
	self.visible = visible
	print("StopMousePanel visible: " + str(self.visible))
