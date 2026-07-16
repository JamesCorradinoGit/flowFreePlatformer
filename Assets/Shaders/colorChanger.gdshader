shader_type canvas_item;

uniform vec4 origin: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 newColor: source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 curUV = texture(TEXTURE, UV);
	if(curUV == origin)
	{
		COLOR = newColor;
	}
}

