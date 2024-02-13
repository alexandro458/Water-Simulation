Shader "Custom/WaterShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Transparency ("Transparency", Range(0,1)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow
        #pragma target 3.0

        #include "WavesCalc.cginc"
        #include "Flow.cginc"

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        float _Transparency;

        void vert (inout appdata_full v) {        
              float3 normal = float3(0, 1, 0);
              v.vertex.xyz = WaveSum(_WaveA, v.vertex.xyz, _Iterations, normal);
              v.normal = normal;
          }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            
            float3 normal = float3(0, 1, 0);

			o.Albedo = WaveColor(IN.uv_MainTex, IN.worldPos, o.Normal, normal);
            o.Normal = normal;

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = _Transparency;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
