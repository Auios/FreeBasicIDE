float4x4 matWorldViewProjection;
sampler2D splatMap = sampler_state
{ 
   ADDRESSU = WRAP; 
   ADDRESSV = WRAP; 
   ADDRESSW = WRAP; 
}; 
sampler2D layer_red  = sampler_state
{ 
   MipFilter = LINEAR; 
   MinFilter = LINEAR; 
   MagFilter = LINEAR; 
   ADDRESSU = WRAP; 
   ADDRESSV = WRAP; 
   ADDRESSW = WRAP; 
}; 

sampler2D layer_green = sampler_state
{ 
   MipFilter = LINEAR; 
   MinFilter = LINEAR; 
   MagFilter = LINEAR; 
   ADDRESSU = WRAP; 
   ADDRESSV = WRAP; 
   ADDRESSW = WRAP; 
}; 

sampler2D layer_blue = sampler_state
{ 
   MipFilter = LINEAR; 
   MinFilter = LINEAR; 
   MagFilter = LINEAR; 
   ADDRESSU = WRAP; 
   ADDRESSV = WRAP; 
   ADDRESSW = WRAP; 
}; 

struct VS_INPUT 
{ 
   float4 Position : POSITION0; 
   float2 alphamap : TEXCOORD0; 
   float2 tex : TEXCOORD1;
   }; 

struct VS_OUTPUT 
{ 
   float4 Position : POSITION0; 
   float2 alphamap : TEXCOORD0; 
   float2 tex : TEXCOORD1;
   }; 

struct PS_OUTPUT 
{ 
   float4 diffuse : COLOR0; 
}; 

VS_OUTPUT vs_main(in VS_INPUT Input) 
{ 
   VS_OUTPUT Output; 
   Output.Position = mul( Input.Position, matWorldViewProjection );
   Output.alphamap = Input.alphamap; 
   Output.tex = Input.tex;
   return( Output ); 
} 

PS_OUTPUT ps_main(in VS_OUTPUT input) 
{ 
   float texScale = 10.0f; 	
   PS_OUTPUT output = (PS_OUTPUT)0; 

   float4 a = tex2D(splatMap, input.alphamap); 
   float4 i = tex2D(layer_red, input.tex*texScale);
   float4 j = tex2D(layer_green, input.tex*texScale); 
   float4 k = tex2D(layer_blue, input.tex*texScale); 

  // float4 i1=a.r*i*a.a; 
  // float4 j1=a.g*j*a.a; 
  // float4 k1=a.b*k*a.a;
 
 
  output.diffuse  = float4(a.r*i+a.g*j+a.b*k)*float4(1,1,1,a.a);

  // output.diffuse = i1+j1+k1; 
   //output.diffuse = i1+j1+k1; 
   return output;

  



 
} 

technique Default_DirectX_Effect 
{ 
   pass Pass_0 
   { 
      VertexShader = compile vs_2_0 vs_main(); 
      PixelShader = compile ps_2_0 ps_main(); 
   } 

}