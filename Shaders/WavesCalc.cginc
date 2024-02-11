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