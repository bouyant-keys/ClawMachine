extends TextureButton

@export var level_index : int

signal load_level(index:int)

func on_level_button_pressed() ->void:
	emit_signal("load_level", level_index)
