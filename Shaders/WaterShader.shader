Shader "Custom/WaterShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
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

        sampler2D _MainTex;

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
        int _Iterations;

        float _SteepDiff, _LengthDiff;
        float2 _DirDiff;

        float4 _WaveA;

        float3 GerstnerWave (
		float4 wave, float3 p, inout float3 tangent, inout float3 binormal
		) {
		    float steepness = wave.z;
		    float wavelength = wave.w;
		    float k = 2 * UNITY_PI / wavelength;
			float c = sqrt(9.8 / k);
			float2 d = normalize(wave.xy);
			float f = k * (dot(d, p.xz) - c * _Time.y);
			float a = steepness / k;

			tangent += float3(
				-d.x * d.x * (steepness * sin(f)),
				d.x * (steepness * cos(f)),
				-d.x * d.y * (steepness * sin(f))
			);
			binormal += float3(
				-d.x * d.y * (steepness * sin(f)),
				d.y * (steepness * cos(f)),
				-d.y * d.y * (steepness * sin(f))
			);
			return float3(
				d.x * (a * cos(f)),
				a * sin(f),
				d.y * (a * cos(f))
			);
		}
        float3 WaveSum(float4 wave, float3 pos, int iterations, out float3 normal)
        {
            float3 gridPoint = pos;
            float3 tangent = float3(1, 0, 0);
			float3 binormal = float3(0, 0, 1);
			float3 p = gridPoint;

            for(int i = 0; i < iterations; i++)
            {
                float2 dir = float2(wave.x + (_DirDiff.x * i), wave.y + (_DirDiff.y * i));
                float weight = 1.0 - (i / iterations);
                float steepness = wave.z - (_SteepDiff * i);
                float waveLength = wave.a - (_LengthDiff * i);
                float4 fixedWave = float4(dir, steepness, waveLength);
                p += GerstnerWave(fixedWave, gridPoint, tangent, binormal);
            }

            normal = normalize(cross(binormal, tangent));

            return p;
        }

        void vert (inout appdata_full v) {

              float3 normal = float3(0, 1, 0);

              v.vertex.xyz = WaveSum(_WaveA, v.vertex.xyz, _Iterations, normal);

              v.normal = normal;
          }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float height = IN.worldPos.y;
            float gradientRange = _GradientAmplitude / 2;
            float a = (height - (gradientRange * -1)) / (gradientRange - (gradientRange * -1));
            fixed4 col = lerp(_DeepWaterColor, _WaterColor, a);


            o.Albedo = col.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = _Transparency;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
