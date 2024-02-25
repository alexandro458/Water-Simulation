Shader "Custom/WaterShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 200

        GrabPass {"_WaterBackground"}

        CGPROGRAM
        #pragma surface surf Standard alpha vertex:vert finalcolor:ResetAlpha
        #pragma target 3.0

        #include "WavesCalc.cginc"
        #include "Flow.cginc"
        #include "Transparency.cginc"

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
            float3 modelPosition;
            float4 screenPos;
        };

        half _Glossiness;
        half _Metallic;
        float _Transparency;

        void vert (inout appdata_full v, out Input o) {
              UNITY_INITIALIZE_OUTPUT(Input, o);
              float3 normal = float3(0, 1, 0);

              float3 worldVertex = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0));

              float3 gerstnerPoint = WaveSum(_WaveA, worldVertex, _Iterations, normal);

              gerstnerPoint = mul(unity_WorldToObject, float4(gerstnerPoint, 1.0));
              v.vertex.xyz = gerstnerPoint;

              o.modelPosition = v.vertex.xyz;
              v.normal = normal;
          }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            
            float3 normal = float3(0, 1, 0);

            float3 col = WaveColor(IN.uv_MainTex, IN.modelPosition, o.Normal, normal);

			o.Albedo = col;
            o.Alpha = _Transparency;
            o.Normal = normal;

			o.Emission = ColorBelowWater(IN.screenPos, o.Normal) * (1 - _Transparency);     

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
        }

        void ResetAlpha (Input IN, SurfaceOutputStandard o, inout fixed4 color) {
			color.a = 1;
		}
        ENDCG
    }
}
