using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class WaterController : MonoBehaviour
{
    public bool updateStatics = true;

    [Range(0, 2)]
    public float waveAmplitude = 0.1f;

    public float waveSpeed = 1.0f;
    public float waveLength = 1.0f;
    public Color waterColor = Color.blue;

    public Vector4 waveDirection = new Vector4(1.0f, 0.0f, 0.0f, 0.0f);

    public float wavesDifference = 1.0f;

    [Range(0, 1)]
    public float steepness = 1.0f;

    public int wavesIterations = 2;

    private Material waterMaterial;

    private void Start()
    {
        waterMaterial = gameObject.GetComponent<MeshRenderer>().sharedMaterial;

        waterMaterial.SetFloat("_WaveAmplitude", waveAmplitude);
        waterMaterial.SetFloat("_WaveSpeed", waveSpeed);
        waterMaterial.SetFloat("_WaveLenght", waveLength);
        waterMaterial.SetFloat("_WavesDifference", wavesDifference);
        waterMaterial.SetFloat("_Steepness", steepness);
        waterMaterial.SetInt("_WavesIterations", wavesIterations);
        waterMaterial.SetVector("_WaveDirection", waveDirection);
        waterMaterial.SetColor("_WaterColor", waterColor);
    }

    private void Update()
    {
        if (updateStatics)
        {
            waterMaterial.SetFloat("_WaveAmplitude", waveAmplitude);
            waterMaterial.SetFloat("_WaveSpeed", waveSpeed);
            waterMaterial.SetFloat("_WaveLenght", waveLength);
            waterMaterial.SetFloat("_WavesDifference", wavesDifference);
            waterMaterial.SetFloat("_Steepness", steepness);
            waterMaterial.SetInt("_WavesIterations", wavesIterations);
            waterMaterial.SetVector("_WaveDirection", waveDirection);
            waterMaterial.SetColor("_WaterColor", waterColor);
        }
    }
}
