Shader "Unlit/WaterSimV1"
{
    Properties
    {
        _WaterColor ("Water Color", Color) = (1, 1, 1, 1)
        _WaveStrength ("Wave Strength", Float) = 0.1
        _WaveSpeed ("Wave Speed", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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

            float _WaveStrength;
            float _WaveSpeed;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0));

                float wave = sin(v.vertex.x + _Time.y * _WaveSpeed) * _WaveStrength;
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
