extends TextureButton

@export var normal_tex : Texture2D
@export var normal_tex_press : Texture2D
@export var alt_tex : Texture2D
@export var alt_tex_press : Texture2D
@export var is_grab_button := false
var show_normal := true


func _ready() -> void:
	texture_normal = normal_tex
	texture_pressed = normal_tex_press

# call on button release
func swap_button_texture() ->void:
	if is_grab_button:
		show_normal = Player.grabbing
	else:
		show_normal = !show_normal
	
	if show_normal:
		texture_normal = normal_tex
		texture_pressed = normal_tex_press
	else:
		texture_normal = alt_tex
		texture_pressed = alt_tex_press
