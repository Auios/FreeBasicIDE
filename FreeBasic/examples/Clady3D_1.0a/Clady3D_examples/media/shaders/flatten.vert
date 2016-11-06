uniform int TIME_FROM_INIT;

void main(void)
{
	//gl_TexCoord[0] = gl_MultiTexCoord0;
	vec4 v = vec4(gl_Vertex);
	
	v.z = sin(5.0*v.x + float(TIME_FROM_INIT)*0.01)*0.25;
	
	gl_Position = gl_ModelViewProjectionMatrix * v;
} 
