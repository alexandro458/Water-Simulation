Shader "Unlit/WaterSimV1"
{
    Properties
    {

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 _WaterColor;

            float _WaveAmplitude, _WaveSpeed, _WaveLenght;
            float4 _WaveDirection;

            float _WavesDifference;

            int _WavesIterations;

            float WaveCalculation(float2 pos, float time, float amplitude, float waveLength)
            {
                float w = 2 / waveLength;
                float phase = _WaveSpeed * w;
                float directionDot = dot(_WaveDirection, float4(pos, 0, 0));

                float wave = amplitude * sin(directionDot * w + time * phase);
                return wave;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0));

                float wave = 0;

                for (int i = 0; i < _WavesIterations; i++) {
                    float diff = _WavesDifference * i;
                    wave += WaveCalculation(float2(o.vertex.xz), _Time.y + diff * 2, _WaveAmplitude + diff, _WaveLenght + diff);
                }
                o.vertex.y += wave;

                o.vertex = mul(UNITY_MATRIX_V, o.vertex);
				o.vertex = mul(UNITY_MATRIX_P, o.vertex);

                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _WaterColor;

                return col;
            }
            ENDCG
        }
    }
}
