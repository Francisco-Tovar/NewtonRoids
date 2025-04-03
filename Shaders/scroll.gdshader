shader_type canvas_item;

uniform float xSpeed = 0.1;
uniform float ySpeed = 0.1;
//fract(sin(dot(UV.xy, vec2(12.9898,78.233))) * 43758.5453123)

void vertex() {
	UV.x += TIME * xSpeed;
	UV.y -= TIME * ySpeed;
}


