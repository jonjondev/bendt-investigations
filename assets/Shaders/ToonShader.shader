shader_type spatial;
render_mode ambient_light_disabled;

uniform vec4 base_colour: hint_color = vec4(1.0);

const vec4 ambient_colour = vec4(0.4, 0.4, 0.4, 1.0);
const vec4 specular_colour = vec4(0.9, 0.9, 0.9, 1);
const float glossiness = 32.0;
const vec4 rim_colour = vec4(1.0, 1.0, 1.0, 1.0);
const float rim_size = 0.716;
const float rim_threshold = 0.1;

void light() {
	// Get direction of light from current surface normal
	float n_dot_l = dot(NORMAL, LIGHT);
	
	// Get shadow value from attenuation
	float shadow = length(ATTENUATION);
	
	// Discretise lighting on surface into to two distinct shades, based on shadow
	float light_intensity = smoothstep(0, 0.01, n_dot_l * shadow);
	// Add light colour to light intensity
	vec4 light = light_intensity * vec4(LIGHT_COLOR, 0.0);
	
	// Get direction of light reflection from camera
	vec3 half_vector = normalize(LIGHT + VIEW);
	float n_dot_h = dot(NORMAL, half_vector);
	
	// Weaken the specular by its glossiness
	float specular_intensity = pow(n_dot_h * light_intensity, glossiness * glossiness);
	// Discretise specularity on surface into two distinct shades
	specular_intensity = smoothstep(0.005, 0.01, specular_intensity);
	// Add specular colour to specular intensity
	vec4 specular = specular_intensity * specular_colour;
	
	// Get the inverse direction of the surface from camera
	float rim_dot = 1.0 - dot(NORMAL, VIEW);
	// Strengthen the rim on lit surfaces
	float rim_intensity = rim_dot * pow(n_dot_l, rim_threshold);
	// Discretise the rim on surface into two distinct shades
	rim_intensity = smoothstep(rim_size - 0.01, rim_size + 0.01, rim_intensity);
	// Add rim colour to rim intensity
	vec4 rim = rim_intensity * rim_colour;
	
	// Add all modifiers to ambient colour (grey) and multiply by base colour
	vec4 diffuse = (ambient_colour + light + specular + rim) * base_colour;
	DIFFUSE_LIGHT = diffuse.rgb;
}

