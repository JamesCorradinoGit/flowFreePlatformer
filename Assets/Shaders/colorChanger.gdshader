shader_type canvas_item;

uniform vec4 origin: source_color;
uniform vec4 newColor: source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 curUV = texture(TEXTURE, UV);
	if(curUV == origin)
	{
		COLOR = newColor;
	}
}

