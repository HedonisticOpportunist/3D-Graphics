Shader "Pattern"
{
    //show values to edit in inspector
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        // Determines how quickly the distorted object moves
        _Amplitude ("Wave Size", Range(0,1)) = 0.4
        _Frequency ("Wave Freqency", Range(1, 8)) = 2

        // Allows for customisiation of colours on the checker pattern 
        _FirstColour("Color 1", Color) = (0,0,0,1)
        _SecondColour("Color 2", Color) = (1,1,1,1)
        _Density ("Density", Range(2,50)) = 30
    }

    SubShader
    {
        Tags{ "RenderType"="Opaque" "Queue"="Geometry"}


        Pass{
            CGPROGRAM
            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            float _Frequency, _Amplitude, _Density;
            float4 _FirstColour, _SecondColour; 
            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float3 worldPos : TEXCOORD0;
            };

            v2f vert(appdata vertexData)
            {
                // Vertices are in local/model space, so they are relative to the camera and local to the object 
                // Vectors are used as an [x, y, z] position to describe the displacement of a vertex relative to the origin.
                // Matrices are used to represent coordinate spaces, describing the origin and orientation of a space in which all positions 
                // in that space are placed relative to
                v2f output;
    
                // sine angle = opposite / hypotenuse of a right-angled triangle
                vertexData.vertex.xyz += sin(vertexData.vertex.x * _Frequency + _Time.y) * _Amplitude; // the frequency and amplitude are customisable uniform variables
    
                // Transforms a vertex point from model/local space to a camera's world space, then to a view space.
                // The model is used to transform, scale or rotate a model/object to its place in the world (the world space).
                // The view space is the space seen from the camera's point of view.
                // Objects can be transformed to the view space by combining transformations and rotations using a view matrix.
                // The clip space discarded any coordinates not to be used, turning others into fragments. 
                // This is done using a projection matrix, then translated to a screen view. 
                // The past function for one used below in Unity was mul(UNITY_MATRIX_MVP, v.vertex)
                output.position = UnityObjectToClipPos(vertexData.vertex);
    
                // The customisable density value allows for the vertices to be altered, i.e. changing the density
                // worldPos below is the result of calculating the vertex's position in the world 
                output.worldPos = mul(unity_ObjectToWorld, vertexData.vertex) * _Density;
                return output;

            }

           fixed4 frag(v2f i) : SV_TARGET
           {
                // The pattern is determined by the interpolated output from the vertex's processing function 
                // The pattern is determined by taking the floor of the vertex's coordinates in the world position, which are added together
                float pattern = floor(i.worldPos.x) + floor(i.worldPos.y) + floor(i.worldPos.z); 
                pattern = frac(pattern * 0.5); // Returns the fractional part of a float value, which is then multiplied by 0.5
                pattern *= 2; // The pattern is multiplied  again by two 
                
                // A lerp function creates the customisable colour that is drawn on the shader
                float4 colour = lerp(_FirstColour, _SecondColour, pattern); // FirstColour and Second colours are Inspector values
                return colour;
            }
            ENDCG
        }
    }
    Fallback "VertexLit"
}