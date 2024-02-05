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

            float4 _WaveA, _WaveB, _WaveC;

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0));
                
                float3 gridPoint = v.vertex.xyz;
                float3 tangent = float3(1, 0, 0);
			    float3 binormal = float3(0, 0, 1);
			    float3 p = gridPoint;

                p += GerstnerWave(_WaveA, gridPoint, tangent, binormal);
                p += GerstnerWave(_WaveB, gridPoint, tangent, binormal);
                p += GerstnerWave(_WaveC, gridPoint, tangent, binormal);
                float3 normal = normalize(cross(binormal, tangent));

                o.vertex.xyz += p;
                o.normal = normal;

                o.worldPos = o.vertex.xyz;

                o.vertex = mul(UNITY_MATRIX_V, o.vertex);
				o.vertex = mul(UNITY_MATRIX_P, o.vertex);

                o.uv = v.uv;
                //o.normal = UnityObjectToWorldNormal(normal);
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

                col = float4(calcLight(col, i.normal, i.worldPos), _Transparency);

                //col = float4(normal.xy, 0.0, 1.0);

                return col;
            }
            ENDCG
        }
    }
}
