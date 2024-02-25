Shader "Custom/WaterShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Transparency ("Transparency", Range(0,1)) = 1.0

        _WaterFogColor ("Water Fog Color", Color) = (0, 0, 0, 0)
		_WaterFogDensity ("Water Fog Density", Range(0, 2)) = 0.1
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
              v.vertex.xyz = WaveSum(_WaveA, v.vertex.xyz, _Iterations, normal);
              o.modelPosition = v.vertex.xyz;
              v.normal = normal;
          }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            
            float3 normal = float3(0, 1, 0);

            float3 col = WaveColor(IN.uv_MainTex, IN.modelPosition, o.Normal, normal);

			o.Albedo = col;
            o.Alpha = _Transparency;

			o.Emission = ColorBelowWater(IN.screenPos) * (1 - _Transparency);

            o.Normal = normal;

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
        }

        void ResetAlpha (Input IN, SurfaceOutputStandard o, inout fixed4 color) {
			color.a = 1;
		}
        ENDCG
    }
}
