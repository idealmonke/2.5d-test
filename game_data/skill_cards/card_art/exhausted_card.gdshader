shader_type canvas_item;

// Set from GDScript: true = exhausted, false = active
uniform bool is_exhausted = false;

// Set from GDScript to Time.get_ticks_msec() / 1000.0 (or OS.get_unix_time())
// at the exact moment is_exhausted was last toggled
uniform float transition_start_time = 0.0;

uniform float fade_duration : hint_range(0.01, 5.0) = 0.1;
uniform float darken_amount : hint_range(0.0, 1.0) = 0.75;
uniform float desaturate_amount : hint_range(0.0, 1.0) = 0.75;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	// How far into the fade are we, 0 -> 1, clamped
	float elapsed = TIME - transition_start_time;
	float t = clamp(elapsed / fade_duration, 0.0, 1.0);
	// Smooth the curve a bit instead of linear
	//t = smoothstep(0.0, 1.0, t);

	// If becoming exhausted, fade IN the darken effect; if becoming active, fade it OUT
	float strength = is_exhausted ? t : 1.0 - t;

	// Desaturate: blend toward grayscale (luminance)
	float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
	vec3 desaturated = mix(tex_color.rgb, vec3(gray), desaturate_amount * strength);

	// Darken: multiply toward black
	vec3 darkened = desaturated * mix(1.0, darken_amount, strength);

	COLOR = vec4(darkened, tex_color.a);
}