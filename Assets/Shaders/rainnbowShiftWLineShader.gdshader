shader_type canvas_item;

group_uniforms rainbowBackground;
uniform float shiftTimeMod: hint_range(0.0, 1.0) = 0.5;
uniform float bgRotateAngle: hint_range(0.0, 360, 0.1) = 0.0;
uniform float shiftPositionMod: hint_range(0.0, 2.0, 0.1) = 1.0;

group_uniforms pulseLine;
uniform bool showLine;
uniform vec3 color_one : source_color; 
uniform bool switchLineColor;
uniform float lineRotateAngle: hint_range(0.0, 360, 0.1) = 20.0;
uniform float line_count = 20.0; 
uniform float lineSpeed = 10.0; 
uniform float lineBlur : hint_range(0.0, 2.0, 0.1); 

vec2 lineRotate(vec2 uv, float rotation_angle) {
	float radians_angle = radians(rotation_angle);
	float cos_angle = cos(radians_angle);
	float sin_angle = sin(radians_angle);
	mat2 rotation_matrix = mat2(vec2(cos_angle, -sin_angle), vec2(sin_angle, cos_angle));
	return uv * rotation_matrix;
}

float stripe(vec2 uv) {
	return cos(uv.x * 0.0 - TIME*lineSpeed + uv.y * -line_count/2.0);
}

vec3 shift_hue(in vec4 color, in float shift) {
	// The unit gray vector in RGB color space.
	vec3 gray = vec3(0.57735);
	// Project color onto gray axis.
	vec3 projection = gray * dot(gray, color.rgb);
	// Vector from gray axis to original color.
	vec3 U = color.rgb - projection;
	// Vector perpendicular to gray axis and U.
	vec3 V = cross(gray, U);
	// Rotate U and V around the gray axis.
	vec3 shifted = U * cos(shift * 2.0 * PI) + V * sin(shift * 2.0 * PI) + projection;
	return vec3(shifted);
}

void fragment() {
	vec2 bgUVToRotate = vec2(1.0, 0.5);
	
	vec2 curLocation = UV;
	vec3 rainbowColor = shift_hue(vec4(bgUVToRotate, 1.0, 1.0), mod(curLocation.x * shiftPositionMod, 1.0) + (TIME*shiftTimeMod));
	
	if(showLine){
		vec2 uv = UV;
		vec3 col;
		float a = TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y;
		
		uv.x *= a;
		uv = lineRotate(uv, lineRotateAngle);
		float g = stripe(uv);
		
		if(switchLineColor == true){
			col = mix(rainbowColor, color_one, smoothstep(0.0, lineBlur, g));
		}
		else{
			col = mix(color_one, rainbowColor, smoothstep(0.0, lineBlur, g));
		}
		
		COLOR = vec4(col, 1.0);
	}
	else{
		COLOR = vec4(rainbowColor, 1.0);
	}
}