
uniform sampler2D tex;
void main(void)
{
	//vec4 color1 = texture2D(tex,gl_TexCoord[0].st);
	gl_FragColor = vec4(0.8,0.3,0.3,0.5);
}
