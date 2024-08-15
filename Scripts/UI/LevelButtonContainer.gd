extends HFlowContainer

const disabledColor : Color = Color8(128, 128, 128)

func set_enabled() ->void:
	for i : int in self.get_children().size():
		var button : TextureButton = self.get_child(i) as TextureButton
		button.self_modulate = Color.WHITE

func set_else_disabled(index:int) ->void:
	for i : int in self.get_children().size():
		var button : TextureButton = self.get_child(i) as TextureButton
		if i != index:
			button.self_modulate = disabledColor
