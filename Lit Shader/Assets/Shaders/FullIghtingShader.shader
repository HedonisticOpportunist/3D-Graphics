Shader "Custom/FullLightingShader"
{
	Properties
	{
		_Colour("Colour", Color) = (1.0,1.0,1.0)
		_SpecColour("Color", Color) = (1.0,1.0,1.0)
		_Shininess("Shininess", Float) = 10
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
				uniform float4 _SpecColour;
				uniform float _Shininess;
				
				struct vertexInput
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};

				struct vertexOutput
				{
					float4 position : SV_POSITION;
					float4 colour : COLOR;
					float4 posWorld : TEXCOORD0;
					float4 normalDir : TEXCOORD1;
				};

				vertexOutput vert(vertexInput v)
				{
					vertexOutput output;

	                // The vertex relative to the world space
					output.posWorld = mul(unity_ObjectToWorld, v.vertex);
	
					// The normal relative to world space respectively.
					output.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));

					// The vertex is transformed to view space and then clip space. 
					output.position = UnityObjectToClipPos(v.vertex);
					return output;
				}

			
				float4 frag(vertexOutput i) : COLOR
				{
					// The normalise function is used to return a unit vector. 
					// It represents the direction of the surface. 
					float3 normalDirection = i.normalDir;
	
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
	
					// Calculating specular highlights are the bright spots of light that appear on shiny objects when illuminated. 
					// Reflect - returns the reflection vector given an incident vector and a normal vector.
					// return i - 2.0 * n * dot(n, i); is how it can be implemented
					// Multiplying the light direction by negative one (-1) gives the opposite direction of the light direction vector
					float3 lightReflectDirection = reflect(-lightDirection, normalDirection);
	
					// The view direction is given by subtracting the camera position from the vertex's position.
					// It is then normalised as the direction is required. 
					float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - i.posWorld.xyz));
	
					// How much reflected light can be seen by the camera given by dot product of light reflected direction and the view direction.
					float3 lightSeeDirection = max(0.0, dot(lightReflectDirection, viewDirection));
					
					// _Shininess is a user-defined variable
					float3 shininessPower = pow(lightSeeDirection, _Shininess);
					float3 specularReflection = attenuation * _SpecColour.rgb * shininessPower;
	
					// Full lighting is calculated via the formula: ambient_lighting + diffuse_lighting + specular_lighting
					// For that reason, UNITY_LIGHTMODEL_AMBIENT is added together with diffuse reflection and specular reflection. 
					float3 finalLight = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT;
	
					return float4(finalLight * _Colour.rgb, 1.0);
				}
				ENDCG
			}
		}
	}