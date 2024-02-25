#if !defined(FLOW_INCLUDED)
#define FLOW_INCLUDED

float3 FlowUVW (float2 uv, float2 flowVector, float2 jump, float flowOffset, float tiling, float time, bool flowB) {
	float phaseOffset = flowB ? 0.5 : 0;
	float progress = frac(time + phaseOffset);
	float3 uvw;
	uvw.xy = uv - flowVector * (progress + flowOffset);
	uvw.xy *= tiling;
	uvw.xy += phaseOffset;
	uvw.xy += (time - progress) * jump;
	uvw.z = 1 - abs(1 - 2 * progress);
	return uvw;
}

float3 UnpackDerivativeHeight (float4 textureData) {
			float3 dh = textureData.agb;
			dh.xy = dh.xy * 2 - 1;
			return dh;
		}

#endif


sampler2D  _FlowMap, _DerivHeightMap;

float4 _WaterColor;
float4 _DeepWaterColor;
float _GradientAmplitude, _GradientOffset;

float _UJump, _VJump, _Tiling, _Speed, _FlowStrength, _FlowOffset;
float _HeightScale, _HeightScaleModulated;

int _UseGerstnerNormal, _DegubGradient;

float3 WaveColor(float2 uv, float3 modelPos, float3 preNormal, out float3 normal)
{

	float height = modelPos.y;
    float gradientRange = _GradientAmplitude / 2;
    float a = (height - (gradientRange * -1)) / (gradientRange - (gradientRange * -1));
	a = saturate(a + _GradientOffset);
    fixed4 col = lerp(_DeepWaterColor, _WaterColor, a);

    float3 flow = tex2D(_FlowMap, uv).rgb;
	flow.xy = flow.xy * 2 - 1;
	flow *= _FlowStrength;
    float noise = tex2D(_FlowMap, uv).a;
	float time = _Time.y * _Speed + noise;

    float2 jump = float2(_UJump, _VJump);

    float3 uvwA = FlowUVW(uv, flow.xy, jump, _FlowOffset, _Tiling, time, false);
    float3 uvwB = FlowUVW(uv, flow.xy, jump, _FlowOffset, _Tiling, time, true);

    float finalHeightScale =
		flow.z * _HeightScaleModulated + _HeightScale;

    float3 dhA =
		UnpackDerivativeHeight(tex2D(_DerivHeightMap, uvwA.xy)) *
		(uvwA.z * finalHeightScale);
	float3 dhB =
		UnpackDerivativeHeight(tex2D(_DerivHeightMap, uvwB.xy)) *
		(uvwB.z * finalHeightScale);


	if(_UseGerstnerNormal == 1)
	{ 
	float3 tipNormal = normalize((float3(-(dhA.xy + dhB.xy), 1)) + preNormal);
	float3 gerstnerNormal = preNormal;
	normal = lerp(gerstnerNormal, tipNormal, a);
	}
	else { normal = normalize(float3(-(dhA.xy + dhB.xy), 1)); }

	if(_DegubGradient == 1) { return a.xxx; }

	return col.rgb;
}