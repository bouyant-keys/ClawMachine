shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_nearest;
uniform sampler2D palette : filter_nearest, repeat_disable;
uniform float palette_index = 1.0;

void fragment() {
	//Get color of texture
	vec4 rgba = texture(screen_tex, UV);
	//Convert palette_index to usable value based on palette size
	float palette_v = palette_index / 16.0;
	
	//Get palette color via UV - U = Red channel, V = palette_index
	vec4 final_color = texture(palette, vec2(rgba.r, palette_v)); //may need to divide red by 255
	final_color.a = rgba.a;
	
	COLOR = final_color;
}
