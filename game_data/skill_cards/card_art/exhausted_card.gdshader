shader_type canvas_item;

// Set from GDScript: true = exhausted, false = active
uniform bool is_exhausted = false;
uniform float darken_amount : hint_range(0.0, 1.0) = 0.75;
uniform float desaturate_amount : hint_range(0.0, 1.0) = 0.75;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	// No fade - just fully on or fully off
	float strength = is_exhausted ? 1.0 : 0.0;

	// Desaturate: blend toward grayscale (luminance)
	float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
	vec3 desaturated = mix(tex_color.rgb, vec3(gray), desaturate_amount * strength);

	// Darken: multiply toward black
	vec3 darkened = desaturated * mix(1.0, darken_amount, strength);

	COLOR = vec4(darkened, tex_color.a);
}