shader_type canvas_item;
render_mode blend_mix;

uniform float Stripe_Bias : hint_range(0, 3) = 2;
uniform float Animation_Speed;
uniform float Angle = 45;
uniform vec4 Color1 : source_color = vec4(1.000000, 1.000000, 1.000000, 1.000000);
uniform vec4 Color2 : source_color = vec4(0.000000, 0.000000, 0.000000, 1.000000);
uniform float Stripe_Density : hint_range(1, 5) = 2;

// Varyings
varying vec2 LOCAL_COORD;
varying vec2 MODEL_SCALE;


vec4 quat_from_axis_angle(vec3 axis, float angle) { 
  vec4 qr; 
  float half_angle = (angle * 0.5) * 3.14159 / 180.0;
  qr.x = axis.x * sin(half_angle);
  qr.y = axis.y * sin(half_angle);
  qr.z = axis.z * sin(half_angle);
  qr.w = cos(half_angle);
  return qr;
}

vec3 rotate_vector(vec3 position, vec3 axis, float angle)
{ 
  vec4 q = quat_from_axis_angle(axis, angle);
  vec3 v = position.xyz;
  return v + 2.0 * cross(q.xyz, cross(q.xyz, v) + q.w * v);
}

void vertex() {
    vec2 world_scale = vec2(
        length(vec2(MODEL_MATRIX[0].x, MODEL_MATRIX[1].x)), // scale x axis
        length(vec2(MODEL_MATRIX[0].y, MODEL_MATRIX[1].y)) // scale y axis
    );

    mat4 transform = MODEL_MATRIX;
    float a = length(transform[0]);
    float b = length(transform[1]);
    float c = length(transform[2]);
    float d = length(transform[3]);
    float scale_x = a;
    float scale_y = b;

    MODEL_SCALE = vec2(scale_x, scale_y);
    LOCAL_COORD = VERTEX;
}

float stripe(float angle, float speed, float density, vec2 pixel_size) {
    float ratio = pixel_size.y / pixel_size.x;
    float scale_ratio = MODEL_SCALE.y / MODEL_SCALE.x;
	ratio /= scale_ratio;

    vec2 bla = LOCAL_COORD.xy * pixel_size;
    float w = cos(angle) * bla.x + sin(angle) * bla.y / ratio - speed * TIME;
    w *= density;

    return w;
}

void fragment() {
	float angle = radians(Angle);
    float speed = Animation_Speed;
    float density = Stripe_Density;

    float stripe_dist = stripe(angle, speed, density, TEXTURE_PIXEL_SIZE);

	float bias = Stripe_Bias;
    float mod_dist = mod(stripe_dist, bias);
    mod_dist = floor(mod_dist);

	if(abs(mod_dist) < 0.00100)
	{
		COLOR.rgb = Color2.rgb;
	}
	else
	{
		COLOR.rgb = Color1.rgb;
	}
	
	//COLOR.r = MODEL_SCALE.x;
	//COLOR.g = MODEL_SCALE.y;
	//COLOR.b = 0.0;
}
