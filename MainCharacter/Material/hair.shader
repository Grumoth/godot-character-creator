shader_type spatial;
render_mode blend_mix,depth_draw_alpha_prepass, cull_disabled,diffuse_burley,specular_schlick_ggx;
uniform vec4 hairColor : hint_color; uniform vec4 rootColor:hint_color ;uniform float rootOffset;
uniform vec4 tipColor:hint_color;uniform float tipOffset;
uniform float specular;uniform float metallic;uniform float roughness : hint_range(0,1);
uniform float normal_scale : hint_range(-2,2);uniform float anisotropy_ratio : hint_range(0,1);
uniform float ao_light_affect;
uniform float punch;

uniform sampler2D texture_albedo : hint_albedo;uniform sampler2D texture_metallic : hint_white;
uniform sampler2D texture_normal : hint_normal;
uniform sampler2D masks_rt;
//uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_white;uniform vec4 roughness_texture_channel;

uniform sampler2D texture_flowmap : hint_aniso;
uniform sampler2D texture_ambient_occlusion : hint_white;
uniform vec4 ao_texture_channel;
//uniform float subsurface_scattering_strength : hint_range(0,1);
uniform sampler2D texture_subsurface_scattering : hint_white;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}




void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	vec4 masks_rt_tex = texture(masks_rt,base_uv);
//	ALBEDO = albedo.rgb * albedo_tex.rgb;
//	ALBEDO = mix(albedo.rgb,albedo.rgb+vec3(0.1,0.1,0.1),pow(anisotropy_tex.r,alphaPunch));
	ALBEDO = mix(mix(hairColor.rgb,rootColor.rgb,masks_rt_tex.r*rootOffset),mix(hairColor.rgb,tipColor.rgb,masks_rt_tex.g*tipOffset),0.5);

	vec4 metallic_tex = texture(texture_metallic,base_uv);
	METALLIC = metallic_tex.r * metallic;
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	NORMALMAP = texture(texture_normal,base_uv).rgb;
	NORMALMAP_DEPTH = normal_scale;
	
	
	ALPHA = hairColor.a * albedo_tex.a*punch;
	
	
	vec3 anisotropy_tex = texture(texture_flowmap,base_uv).rga;
	ANISOTROPY = anisotropy_ratio*anisotropy_tex.b;
//	ANISOTROPY_FLOW = anisotropy_tex.rg*2.0-1.0;
//	TRANSMISSION = mix(vec3(0,0,0),albedo.rgb*20.,pow(anisotropy_tex.r,alphaPunch));
//	AO = dot(texture(texture_ambient_occlusion,base_uv),ao_texture_channel);
	AO = texture(texture_ambient_occlusion,base_uv).r;
	AO_LIGHT_AFFECT = ao_light_affect;
	float sss_tex = texture(texture_subsurface_scattering,base_uv).r;
	
	
	
}
