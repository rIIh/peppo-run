shader_type canvas_item;

uniform mat4 global_transform;
uniform vec2 fade_origin = vec2(0);
uniform vec2 fade_threshold = vec2(250);
uniform float fade_strength = 32.0;

varying vec2 world_position;

void vertex(){
    world_position = (global_transform * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec2 position = world_position;
	
	vec2 a = clamp((abs(position) - fade_threshold + fade_strength) / fade_strength, vec2(0), vec2(1));
	a = pow(-pow(a * 1.025, vec2(2)), vec2(2));
	a = vec2(1) - a;
	
	COLOR.a = COLOR.a * a.x * a.y;
}
