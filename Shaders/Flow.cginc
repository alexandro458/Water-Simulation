#if !defined(FLOW_INCLUDED)
#define FLOW_INCLUDED

float2 FlowUV (float2 uv, float2 flowVector, float time) {
	float progress = frac(time);
	return uv - flowVector * progress;
}

float3 UnpackDerivativeHeight (float4 textureData) {
			float3 dh = textureData.agb;
			dh.xy = dh.xy * 2 - 1;
			return dh;
		}

#endif