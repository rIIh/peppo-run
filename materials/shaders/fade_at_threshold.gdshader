shader_type canvas_item;

uniform vec2 texture_size = vec2(100);
uniform vec2 real_position = vec2(0.0, 0.0);
uniform vec2 threshold = vec2(600);
uniform float fade_distance = 30.0;
uniform float scale = 4.0;

void fragment() {
	vec2 size = 1.0 / TEXTURE_PIXEL_SIZE / scale;
	vec2 position = (UV * 2.0 - vec2(1, 1)) / TEXTURE_PIXEL_SIZE / scale + real_position * 2.0;
	
	vec2 a = vec2(1, 1) - clamp((abs(position) - threshold * 2.0 + fade_distance) / fade_distance, vec2(0, 0), vec2(1, 1));
	
	COLOR.rgb = vec3(0);
	COLOR.r = UV.g;
	//COLOR.a = COLOR.a * a.x * a.y;
}
