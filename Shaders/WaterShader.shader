Shader "Custom/WaterShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Transparency ("Transparency", Range(0,1)) = 1.0

        [NoScaleOffset] _FlowMap ("Flow (RGA)", 2D) = "black" {}

        _UJump ("U jump per phase", Range(-0.25, 0.25)) = 0.25
		_VJump ("V jump per phase", Range(-0.25, 0.25)) = 0.25
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

        sampler2D _MainTex, _FlowMap;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        float _Transparency;
        fixed4 _Color;

        float4 _WaterColor;
        float4 _DeepWaterColor;
        float _GradientAmplitude;

        float _UJump, _VJump;

        void vert (inout appdata_full v) {        
              float3 normal = float3(0, 1, 0);
              v.vertex.xyz = WaveSum(_WaveA, v.vertex.xyz, _Iterations, normal);
              v.normal = normal;
          }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //float height = IN.worldPos.y;
            //float gradientRange = _GradientAmplitude / 2;
            //float a = (height - (gradientRange * -1)) / (gradientRange - (gradientRange * -1));
            //fixed4 col = lerp(_DeepWaterColor, _WaterColor, a);

            float2 flowVector = tex2D(_FlowMap, IN.uv_MainTex).rg * 2 - 1;
            float noise = tex2D(_FlowMap, IN.uv_MainTex).a;
			float time = _Time.y + noise;

            float2 jump = float2(_UJump, _VJump);

            float3 uvwA = FlowUVW(IN.uv_MainTex, flowVector, jump, time, false);
            float3 uvwB = FlowUVW(IN.uv_MainTex, flowVector, jump, time, true);

            fixed4 texA = tex2D(_MainTex, uvwA.xy) * uvwA.z;
            fixed4 texB = tex2D(_MainTex, uvwB.xy) * uvwB.z;

            fixed4 c = (texA + texB) * _Color;
			o.Albedo = c.rgb;

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = _Transparency;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
