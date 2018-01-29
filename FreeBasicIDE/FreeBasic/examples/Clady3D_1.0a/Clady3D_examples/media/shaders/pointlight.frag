/* -------------------------------------------------------

This shader implements a point light per pixel using  the 
diffuse, specular, and ambient terms acoording to "Mathematics of Lighthing" 
as found in the book "OpenGL Programming Guide" (aka the Red Book)

AntÃ³nio Ramires Fernandes

--------------------------------------------------------- */

varying vec4 diffuse,ambientGlobal, ambient;
varying vec3 normal,lightDir,halfVector;
varying float dist;
uniform sampler2D tex;

void main()
{
	vec3 n,halfV,viewV,ldir;
	float NdotL,NdotHV;
	vec4 color = ambientGlobal;
	float att;
	

	vec4 color1 = texture2D(tex,gl_TexCoord[0].st);
	/* a fragment shader can't write a verying variable, hence we need
	a new variable to store the normalized interpolated normal */
	n = normalize(normal);
	
	/* compute the dot product between normal and ldir */
	NdotL = max(dot(n,normalize(lightDir)),0.0);

	if (NdotL > 0.0) {
	
		att = 1.0 / (gl_LightSource[0].constantAttenuation +
				gl_LightSource[0].linearAttenuation * dist +
				gl_LightSource[0].quadraticAttenuation * dist * dist);
		color += att * (diffuse * NdotL + ambient);
	
		
		halfV = normalize(halfVector);
		NdotHV = max(dot(n,halfV),0.0);
		color += att * gl_FrontMaterial.specular * gl_LightSource[0].specular * pow(NdotHV,gl_FrontMaterial.shininess);
	}

	gl_FragColor = color*color1;
}
