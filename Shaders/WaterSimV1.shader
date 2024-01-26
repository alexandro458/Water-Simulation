Shader "Unlit/WaterSimV1"
{
    Properties
    {
        _Transparency("Transparency", Range(0.0, 1.0)) = 0.5
        _Glossiness("Glossiness", Float) = 100.0
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
            #include "Lighting.cginc"

            float _Transparency;
            float _Glossiness;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 worldPos : TEXCOORD1;
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

            float WaveResult(float2 uv)
            {
                float wave = 0;
                for (int i = 0; i < _WavesIterations; i++) {
                    float diff = _WavesDifference * i;
                    wave += WaveCalculation(float2(uv.xy), _Time.y + diff * 2, _WaveAmplitude + diff, _WaveLenght + diff);
                }
                return wave;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0));
                
                o.vertex.y += WaveResult(v.uv);

                o.worldPos = o.vertex.xyz;

                o.vertex = mul(UNITY_MATRIX_V, o.vertex);
				o.vertex = mul(UNITY_MATRIX_P, o.vertex);

                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed3 calcLight(float4 albedo, float3 normal, float3 worldPos)
            {
                //diffuse
                float diffuse = saturate(dot(normal, _WorldSpaceLightPos0));

                //specular
                float3 reflectDir = reflect(-normalize(_WorldSpaceLightPos0), normal);
                float3 viewDir = normalize(_WorldSpaceCameraPos - worldPos);
                float3 halfVec = normalize(_WorldSpaceLightPos0 + viewDir);
                float specular = max(dot(reflectDir , viewDir), 0.0);

                specular = pow(specular * diffuse, _Glossiness);

                fixed4 col = albedo * ((diffuse * _LightColor0) + specular + unity_AmbientSky);
                return col.xyz;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _WaterColor;


                float wave = WaveResult(i.uv.xy);
                float3 normal = normalize(float3(-ddx(wave), 0, -ddy(wave)));

                normal = 0.5 + 0.5 * normal;

                //normal = UnityObjectToWorldNormal(normal);

                col = float4(calcLight(col, normal.xyz, i.worldPos), _Transparency);

                //col = float4(normal.xy, 0.0, 1.0);

                return col;
            }
            ENDCG
        }
    }
}
