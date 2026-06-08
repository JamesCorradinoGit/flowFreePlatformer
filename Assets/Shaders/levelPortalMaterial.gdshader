shader_type canvas_item;

uniform vec4 origin: source_color;
uniform sampler2D portalMask;
uniform bool clockwise = true;
uniform float speed : hint_range(0.0, 2.0) = 1.0;

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
			vec2(cos(angle), sin(angle)));
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}
void fragment() {
	vec4 baseCol = texture(TEXTURE, UV);
	float direction = clockwise ? 1.0 : -1.0;
	vec2 rotatedUv = rotate(UV, vec2(0.5), TIME * speed * direction);
	
	if (baseCol == origin)
	{
		COLOR = texture(portalMask, rotatedUv);
	}
}

