#version 430 // change later

// Eingabe-Werte pro Vertex
in vec4 vVertex; // Vertex-Position in Objektkoordinaten

// Uniform-Eingabe-Werte
uniform mat4 MV; // ModelView-Matrix
uniform mat3 NormalM; // Normalen-Matrix

// Structures
// =============================================================================================================
struct Matrices
{
	mat4 mvp;
	mat4 mv;
	mat3 normal;

	mat2 uv;
};


struct Light
{
    vec3 lightPos;
	vec4 ambient;
	vec4 diffus;
	vec4 specular;
};

struct Material 
{
	vec4 ambient;
	vec4 diffus;
	vec4 spekular;
	vec4 emissiv;
	float shininess;
};


struct FragmentInput
{
    vec3 normal;
	vec3 lightDir;
	vec3 viewDir;
	vec2 uv;
};

struct Normalized
{
    vec3 normal;
    vec3 lightDir;
    vec3 viewDir;
};

struct Textures
{
	sampler2D tex;
};

// Subroutines
// =============================================================================================================
subroutine void FragmentProgram();
// =============================================================================================================




// Variables
// =============================================================================================================
layout(location = 0) in FragmentInput Input;

uniform Matrices matrices;

uniform Light light;
uniform Material material;

uniform Textures textures;
uniform float animStage;


subroutine uniform FragmentProgram fragmentprogram;

layout(location = 0) out vec4 out_color;
// =============================================================================================================




// Methods
// =============================================================================================================
void main()
{
	fragmentprogram();
}
// =============================================================================================================



// Subroutine Implementation
// =============================================================================================================
layout (index = 0) subroutine (FragmentProgram) void toon()
{
    Normalized n;
    n.viewDir = normalize(Input.viewDir);
    n.lightDir = normalize(Input.lightDir);
    n.normal = normalize(Input.normal);

    float intensity = dot(n.lightDir, n.normal);

    vec4 toon = vec4(1.f);

    if(abs(intensity) > .9f)
        toon = vec4(1.f);

    else if(abs(intensity) > .8f)
        toon = vec4(.8f);

    else if(abs(intensity) > .7f)
        toon = vec4(.7f);

    else if(abs(intensity) > .6f)
        toon = vec4(.6f);

    else if(abs(intensity) > .5f)
        toon = vec4(.5f);

    else if(intensity > .4f)
        toon = vec4(.4f);

    else if(intensity > .3f)
        toon = vec4(.3f);

    else
        toon = vec4(.2f);

    toon.w = 1.f;


    out_color = toon * vec4((Input.normal * .5f) + .5f, 1);
}

// Subroutine einfarbing Rot
// =============================================================================================================
layout (index = 1) subroutine (FragmentProgram) void red()
{

    out_color = vec4(1,0,0,1);
}
// Subroutine �ndern mit Parameter
// =============================================================================================================
layout (index = 2) subroutine (FragmentProgram) void changeByParam()
{

    //out_color = vec4(Input.lightDir.xyz,1);
	out_color = vec4((Input.normal * .5f) + .5f, 1);
}
// =============================================================================================================
layout (index = 3) subroutine (FragmentProgram) void phong()
{
	Normalized n;
    n.viewDir = normalize(Input.viewDir);
    n.lightDir = normalize(Input.lightDir);
    n.normal = normalize(Input.normal);

	vec4 ambient = light.ambient * material.ambient; 
	float d = dot(n.normal, n.lightDir);
	vec4 diffus = d*light.diffus*material.diffus;
	vec4 specular = vec4(0.f, 0.f, 0.f, 1.f);
	if (d > 0.f) {
		vec3 r = reflect(-n.lightDir, n.normal);
		specular = pow(max(dot(normalize (r), n.normal), 0), material.shininess)*light.specular*material.spekular;
	}
	
	out_color = material.emissiv + ambient  + specular + diffus;
}

layout (index = 4) subroutine (FragmentProgram) void textured()
{
	Normalized n;
    n.viewDir = normalize(Input.viewDir);
    n.lightDir = normalize(Input.lightDir);
    n.normal = normalize(Input.normal);

	vec4 ambient = light.ambient * material.ambient; 
	float d = dot(n.normal, n.lightDir);
	vec4 diffus = d*light.diffus*material.diffus;
	vec4 specular = vec4(0.f, 0.f, 0.f, 0.f);
	if (d > 0.f) {
		vec3 r = reflect(-n.lightDir, n.normal);
		specular = pow(max(dot(normalize (r), n.normal), 0), material.shininess)*light.specular*material.spekular;
	}
	vec4 texOrTransparant = texture(textures.tex, Input.uv);

	if(dot(Input.uv - vec2(0.5f, 0.5f), Input.uv - vec2(0.5f, 0.5f)) > 0.25f){
		discard; // = wegwerfen
	}
	if(dot(Input.uv - vec2(0.5f, 0.5f), Input.uv - vec2(0.5f, 0.5f)) < 0.15f){
		discard; // = wegwerfen
	}
	
	out_color = texOrTransparant + ambient  + specular + diffus;
}

layout (index = 5) subroutine (FragmentProgram) void moonShine()
{
	vec4 moonShineEmission = vec4(0.5f, 0.5f, 0.5f, 1.f);
	Normalized n;
    n.viewDir = normalize(Input.viewDir);
    n.lightDir = normalize(Input.lightDir);
    n.normal = normalize(Input.normal);

	vec4 ambient = light.ambient * material.ambient; 
	float d = dot(n.normal, n.lightDir);
	vec4 diffus = d*light.diffus*material.diffus;
	vec4 specular = vec4(0.f, 0.f, 0.f, 1.f);
	if (d > 0.f) {
		vec3 r = reflect(-n.lightDir, n.normal);
		specular = pow(max(dot(normalize (r), n.normal), 0), material.shininess)*light.specular*material.spekular;
	}
	
	out_color = (material.emissiv + moonShineEmission) + ambient  + specular + diffus;
}