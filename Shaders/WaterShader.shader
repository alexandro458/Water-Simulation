Shader "Custom/WaterShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Transparency ("Transparency", Range(0,1)) = 1.0
        _Scale ("Transparency", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard alpha vertex:vert
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

        float _Scale;

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

			o.Albedo = ColorBelowWater(IN.screenPos, _Scale);
			o.Alpha = 1;

            o.Normal = normal;

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
        }
        ENDCG
    }
}
