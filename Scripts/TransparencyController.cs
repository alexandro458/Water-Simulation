using UnityEngine;

[ExecuteInEditMode]
public class TransparencyController: MonoBehaviour
{
    public bool updateStatics = true;

    [Range(0.0f, 1.0f)]
    public float transparency = 0.5f;

    public Color waterFogColor = Color.blue;

    [Range(0.0f, 2.0f)]
    public float waterFogDensity = 0.1f;

    [Range(0.0f, 10.0f)]
    public float refractionStrength = 1.5f;

    private Material waterMaterial;

    private void Start()
    {
        waterMaterial = gameObject.GetComponent<MeshRenderer>().sharedMaterial;

        waterMaterial.SetColor("_WaterFogColor", waterFogColor);

        waterMaterial.SetFloat("_Transparency", transparency);
        waterMaterial.SetFloat("_WaterFogDensity", waterFogDensity);
        waterMaterial.SetFloat("_RefractionStrength", refractionStrength);
    }

    private void Update()
    {
        if (updateStatics)
        {
            waterMaterial = gameObject.GetComponent<MeshRenderer>().sharedMaterial;

            waterMaterial.SetColor("_WaterFogColor", waterFogColor);

            waterMaterial.SetFloat("_Transparency", transparency);
            waterMaterial.SetFloat("_WaterFogDensity", waterFogDensity);
            waterMaterial.SetFloat("_RefractionStrength", refractionStrength);
        }
    }
}
