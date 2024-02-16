#if !defined(LOOKING_THROUGH_WATER_INCLUDED)
#define LOOKING_THROUGH_WATER_INCLUDED

sampler2D _CameraDepthTexture;

float3 ColorBelowWater (float4 screenPos, float scale) {
	float2 uv = screenPos.xy / screenPos.w;
	float backgroundDepth =
		LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv));
	float surfaceDepth = UNITY_Z_0_FAR_FROM_CLIPSPACE(screenPos.z);

	float depthDifference = backgroundDepth - surfaceDepth;
	
	return depthDifference / scale;
}

#endif