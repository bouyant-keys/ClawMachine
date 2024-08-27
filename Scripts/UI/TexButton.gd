extends TextureButton

@export var normal_tex : Texture2D
@export var normal_tex_press : Texture2D
@export var alt_tex : Texture2D
@export var alt_tex_press : Texture2D
@export var is_grab_button := false
@export_node_path() var press_sfx_path

var show_normal := true
var press_sfx : AudioStreamPlayer


func _ready() -> void:
	press_sfx = get_node(press_sfx_path) as AudioStreamPlayer
	texture_normal = normal_tex
	texture_pressed = normal_tex_press


# Buttons textures may be incorrect when going from level->menu->level again,
# this should reset them based on their respective global static properties
func reset_state() ->void:
	if is_grab_button:
		show_normal = !Player.grabbing
	else:
		show_normal = !GameManager.instance.paused 
	
	if show_normal:
		texture_normal = normal_tex
		texture_pressed = normal_tex_press
	else:
		texture_normal = alt_tex
		texture_pressed = alt_tex_press


# call on button release
func swap_button_texture() ->void:
	if is_grab_button:
		show_normal = !Player.grabbing
	else:
		show_normal = !show_normal
	
	press_sfx.play()
	
	if show_normal:
		texture_normal = normal_tex
		texture_pressed = normal_tex_press
	else:
		texture_normal = alt_tex
		texture_pressed = alt_tex_press
