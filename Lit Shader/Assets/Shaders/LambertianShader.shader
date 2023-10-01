Shader"Custom/LambertianShader"
{
	Properties
	{
		_Colour("Colour", Color) = (1.0,1.0,1.0)
	}

		SubShader
		{
			Tags {"LightMode" = "ForwardBase"}
			Pass
			{
				
				CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag
				
				uniform float4 _Colour;
				uniform float4 _LightColour0;
				
				struct vertexInput
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};

				struct vertexOutput
				{
					float4 position : SV_POSITION;
					float4 colour : COLOR;
				};


				
				vertexOutput vert(vertexInput v)
				{
					vertexOutput output;

	                // To get the normal direction, the surface normal (which is in modal space) needs to be transformed in world space.
					// For that reason, the surface normal is multiplied by the unity_WorldToObject matrix. 
					// The normalise function is used to return a unit vector. 
					// It represents the direction of the surface. 
					float3 normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
	
					// Light direction relative to the world space, which is normalised to a unit vector
					// It represents L or the light direction. 
					float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
	
					// The dotProduct function calculates the light intensity by finding the dot product of the light direction and normal direction.
					// Since the dot product can be negative, max is used to filter out vertices where light does not fall 
					float dotProduct = max(0.0, dot(normalDirection, lightDirection));
	
					// The attenuation variable provides strength of light that falls on the surface. 
					float attenuation = 1.0;
	
					// The formula below corresponds to Incident Light Energy * N.L
					// _LightColour0.xyz gives the colour of the direction light, while _Colour.rgb is the colour of the user-defined variable
					float3 diffuseReflection = attenuation * _LightColour0.xyz * _Colour.rgb * dotProduct;
	
					// The vertex is transformed to view space and then clip space. 
					output.position = UnityObjectToClipPos(v.vertex);
					return output;
				}

			
				float4 frag(vertexOutput i) : COLOR
				{
					// Outputs the colour of the fragment 
					return i.colour;
				}
				ENDCG
			}
		}
	}