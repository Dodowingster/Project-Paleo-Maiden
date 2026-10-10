shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float edge_width : hint_range(0.0, 0.5) = 0.08;
uniform float opaqueness : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	vec2 centered = UV - vec2(0.5);
	float angle = atan(centered.x, -centered.y);
	if (angle < 0.0) {
		angle += TAU;
	}
	float angle_progress = angle / TAU;

	float reveal_mask = 1.0 - smoothstep(progress, progress + edge_width, angle_progress);
	//float trailoff_mask = smoothstep(progress, progress + edge_width, angle_progress);
	float alpha = tex.a * opaqueness * reveal_mask;

	COLOR = vec4(1.0, 1.0, 1.0, alpha);
}
