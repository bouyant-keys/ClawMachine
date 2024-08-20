extends Panel

const disabled_color : Color = Color8(128, 128, 128)

@export_node_path() var tex_path
@export_node_path() var button_path

@onready var tex : TextureRect = get_node(tex_path)
@onready var button : Button = get_node(button_path)

func set_enabled() ->void:
	tex.self_modulate = Color.WHITE
	button.self_modulate = Color.WHITE

func set_disabled() ->void:
	tex.self_modulate = disabled_color
	button.self_modulate = disabled_color
