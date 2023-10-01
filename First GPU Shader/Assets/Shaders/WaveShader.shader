Shader"Waves" 
{
	Properties 
	{
		_Colour ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0		
		_WaveA ("Wave A (dir, steepness, wavelength)", Vector) = (1,0,0.5,10)
		_WaveB ("Wave B", Vector) = (0,1,0.25,20)
		_WaveC ("Wave C", Vector) = (1,1,0.15,10)
	}
	
	SubShader 
	{
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows vertex:vert
		#pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        float4 _Colour, _WaveA, _WaveB, _WaveC;

        float3 GerstnerWave(float4 wave, float3 p, inout float3 tangent, inout float3 binormal)
        {
            float steepness = wave.z; // Determines the steepness of a wave
            float wavelength = wave.w; // Determines the wave length
            float k = 2 * UNITY_PI / wavelength;
            float c = sqrt(9.8 / k);
            float2 d = normalize(wave.xy);
            float f = k * (dot(d, p.xz) - c * _Time.y);
            float a = steepness / k;

            tangent += float3(-d.x * d.x * (steepness * sin(f)), d.x * (steepness * cos(f)), -d.x * d.y * (steepness * sin(f)));
            binormal += float3(-d.x * d.y * (steepness * sin(f)), d.y * (steepness * cos(f)), -d.y * d.y * (steepness * sin(f)));
			
            return float3(d.x * (a * cos(f)), a * sin(f), d.y * (a * cos(f)));
        }

        void vert(inout appdata_full vertexData)
        {
            float3 gridPoint = vertexData.vertex.xyz;
            float3 tangent = 0;
            float3 binormal = 0;
            float3 p = gridPoint;
    
            // Creating three waves, passed into the GerstnerWave function that returns a 'GerstnerWave'
            // These are calculated using the x, y, z coordinates from the vertex 
            p += GerstnerWave(_WaveA, gridPoint, tangent, binormal);
            p += GerstnerWave(_WaveB, gridPoint, tangent, binormal);
            p += GerstnerWave(_WaveC, gridPoint, tangent, binormal);
            
            // A vertex normal at a vertex of a polyhedron is a directional vector associated with a vertex, 
            // It is intended as a replacement to the true geometric normal of the surface
            // To create the waves, the surface normal is changed by normalising the cross product from the modified binormal and tangent vectors
            float3 normal = normalize(cross(binormal, tangent));
            vertexData.vertex.xyz = p;
            vertexData.normal = normal;
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float4 c = tex2D(_MainTex, IN.uv_MainTex) * _Colour;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
		ENDCG
	   }
    FallBack"Diffuse"
}