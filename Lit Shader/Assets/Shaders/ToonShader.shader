Shader "ToonShader"
{
	Properties
	{
		_Colour("Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
		[HDR]
		_AmbientColour("Ambient Colour", Color) = (0.4,0.4,0.4,1)
		[HDR]
		_SpecularColour("Specular Colour", Color) = (0.9,0.9,0.9,1)
		_Glossiness("Glossiness", Float) = 32
		[HDR]
		_RimColour("Rim Colour", Color) = (1,1,1,1)
		_RimAmount("Rim Amount", Range(0, 1)) = 0.716
		_RimThreshold("Rim Threshold", Range(0, 1)) = 0.1		
	}
	SubShader
	{
		Pass
		{
			// Setup our pass to use Forward rendering, and only receive
			// data on the main directional light and ambient light.
			Tags
			{
				"LightMode" = "ForwardBase"
				"PassFlags" = "OnlyDirectional"
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldNormal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
				SHADOW_COORDS(2)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST, _Colour, _AmbientColour, _SpecularColour, _RimColour;
			float _Glossiness, _RimAmount, _RimThreshold;
			
			v2f vert(appdata v)
			{
				v2f output;
				output.pos = UnityObjectToClipPos(v.vertex);
				output.worldNormal = UnityObjectToWorldNormal(v.normal);
				output.viewDir = WorldSpaceViewDir(v.vertex);
				output.uv = TRANSFORM_TEX(v.uv, _MainTex);
	
				// Defined in Autolight.cginc. Assigns the above shadow coordinate by transforming the vertex from world space to shadow-map space.
				TRANSFER_SHADOW(output);
				return output;
			}
			
			float4 frag(v2f i) : SV_Target
			{
				float3 normal = normalize(i.worldNormal);
	
	            // Calculate the amount of light received by the surface from the main directional light
				float NdotL = dot(_WorldSpaceLightPos0, normal);
	
				// Adds the ability for the shader to cast and receive shadows
				float shadow = SHADOW_ATTENUATION(i);

				// Divide the lighting into two bands, light and dark, to create a more realistic toon effect
				// The smooth step returns a value between 0 and 1 based on how far this third value is between the bounds
				// It blends the transition from 0 to 1. 
				float lightIntensity = smoothstep(0, 0.01, NdotL * shadow);
	
				// Light intensity is calculated with the directional light 
				float4 light = lightIntensity * _LightColor0;
	
				// Calculate specular reflection to model the distinct light from sources
				// Fits in with the formula: Specular Lighting = Cₛ * sum[Lₛ * (N · H)P * Atten * Spot]
				float3 viewDir = normalize(i.viewDir);
	
				// The half vector is between the viewing direction and the light source.  
				float3 halfVector = normalize(_WorldSpaceLightPos0 + viewDir);
	
                // The strength of the specular reflection is defined as the dot product between the normal of the surface and the half vector.
				float NdotH = dot(normal, halfVector);
	
				// Multiply NdotH by lightIntensity to ensure that the reflection is only drawn when the surface is lit 
				float specularIntensity = pow(NdotH * lightIntensity, _Glossiness * _Glossiness);
	
				// The smooth step function is used to toonify the reflection and multiply the final output by the user-defined value specular colour.
				float specularIntensitySmooth = smoothstep(0.005, 0.01, specularIntensity);
				float4 specular = specularIntensitySmooth * _SpecularColour;
	
				// Calculate the rim by taking the dot product of the normal and the view direction, and inverting it.
				float4 rimDot = 1 - dot(viewDir, normal);
	
				// Toonifyy the thresholding the value with smoothstep. Only display rim light on illuminated sufaces of the object. 
				float rimIntensity = rimDot * pow(NdotL, _RimThreshold); // The power function scales the rim. 
                rimIntensity = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, rimIntensity);
				float4 rim = rimIntensity * _RimColour;
	
				float4 sample = tex2D(_MainTex, i.uv);
	
				// Ambient colour is added to ensure that all surfaces receive light uniformly
				// Specular reflection models the individual, distinct reflections made by light sources. 
				// Specular reflection is view-dependent in that it is affected by the angle at which the surface is viewed.
				// Rim lighting is the addition of illumination to the edges of an object to simulate reflected light or backlighting. 
				// Rim lighting is especially useful for toon shaders to help the object's silhouette stand out among the flat shaded surfaces.
				return _Colour * sample * (_AmbientColour + lightIntensity + specular + rim);
			}
			ENDCG
		}

		// Shadow casting support.
		UsePass"Legacy Shaders/VertexLit/SHADOWCASTER"
	}
}