using UnityEngine;

[ExecuteInEditMode]
public class TextureController: MonoBehaviour
{
    public bool updateStatics = true;
    public Color waterColor = Color.blue;
    public Color deepWaterColor = Color.blue;
    public float gradientAmplitude = 50.0f;

    public Texture2D flowMap;
    public Texture2D derivHeightMap;

    [Range(-0.25f, 0.25f)]
    public float uJump, vJump;
    public float tiling, speed, flowStrength, flowOffset;
    public float heightScale, heightScaleModulated;
    [Range(-1, 1)]
    public float gradientOffset;

    public bool useGerstnerNormal;
    public bool debugGradient = false;

    private Material waterMaterial;

    private void Start()
    {
        waterMaterial = gameObject.GetComponent<MeshRenderer>().sharedMaterial;

        waterMaterial.SetTexture("_FlowMap", flowMap);
        waterMaterial.SetTexture("_DerivHeightMap", derivHeightMap);

        waterMaterial.SetColor("_WaterColor", waterColor);
        waterMaterial.SetColor("_DeepWaterColor", deepWaterColor);

        waterMaterial.SetFloat("_GradientAmplitude", gradientAmplitude);
        waterMaterial.SetFloat("_UJump", uJump);
        waterMaterial.SetFloat("_VJump", vJump);
        waterMaterial.SetFloat("_Tiling", tiling);
        waterMaterial.SetFloat("_Speed", speed);
        waterMaterial.SetFloat("_FlowStrength", flowStrength);
        waterMaterial.SetFloat("_FlowOffset", flowOffset);
        waterMaterial.SetFloat("_HeightScale", heightScale);
        waterMaterial.SetFloat("_HeightScaleModulated", heightScaleModulated);
        waterMaterial.SetFloat("_GradientOffset", gradientOffset);

        waterMaterial.SetInt("_UseGerstnerNormal", useGerstnerNormal ? 1 : 0);
        waterMaterial.SetInt("_DegubGradient", debugGradient ? 1 : 0);
    }

    private void Update()
    {
        if (updateStatics)
        {
            waterMaterial = gameObject.GetComponent<MeshRenderer>().sharedMaterial;

            waterMaterial.SetTexture("_FlowMap", flowMap);
            waterMaterial.SetTexture("_DerivHeightMap", derivHeightMap);

            waterMaterial.SetColor("_WaterColor", waterColor);
            waterMaterial.SetColor("_DeepWaterColor", deepWaterColor);

            waterMaterial.SetFloat("_GradientAmplitude", gradientAmplitude);
            waterMaterial.SetFloat("_UJump", uJump);
            waterMaterial.SetFloat("_VJump", vJump);
            waterMaterial.SetFloat("_Tiling", tiling);
            waterMaterial.SetFloat("_Speed", speed);
            waterMaterial.SetFloat("_FlowStrength", flowStrength);
            waterMaterial.SetFloat("_FlowOffset", flowOffset);
            waterMaterial.SetFloat("_HeightScale", heightScale);
            waterMaterial.SetFloat("_HeightScaleModulated", heightScaleModulated);
            waterMaterial.SetFloat("_GradientOffset", gradientOffset);

            waterMaterial.SetInt("_UseGerstnerNormal", useGerstnerNormal ? 1 : 0);
            waterMaterial.SetInt("_DegubGradient", debugGradient ? 1 : 0);
        }
    }
}
