shader_type canvas_item;

uniform sampler2D noise;
uniform float scrollSpeed = 1.0;
uniform float texOffset = 0.0;

void fragment() {
	vec2 new_coords = vec2(0.0, 0.0);
	float scrollOffset = texOffset;
	scrollOffset += scrollSpeed * TIME;
	
	new_coords.x  = (new_coords.x + scrollOffset) * 2.0;
	new_coords.x = mod(new_coords.x, 2.0);
	new_coords.x /= 2.0;
	COLOR = texture(noise, new_coords);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
