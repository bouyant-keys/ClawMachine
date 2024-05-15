shader_type canvas_item;
// An input into the shader from our game code.
// Ranges from 0 to 1 over the course of the transition.
// We use this to actually animate the shader.
uniform float progress : hint_range(0, 1);

// Size of each diamond, in pixels.
uniform float diamondPixelSize = 10.0;

uniform vec2 direction;
uniform float mult = 0.0;

void fragment() {
	float xFraction = fract(FRAGCOORD.x / diamondPixelSize);
	float yFraction = fract(FRAGCOORD.y / diamondPixelSize);
	
	float xDistance = abs(xFraction - 0.5);
	float yDistance = abs(yFraction - 0.5);
	
	if (xDistance + yDistance + (UV.x * direction.x) + (UV.y * direction.y) > (progress + mult) * 2.0) {discard;}
	
	//COLOR = vec4(0.0, 0.0, 0.0, 1.0);
}