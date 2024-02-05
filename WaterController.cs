using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class WaterController : MonoBehaviour
{
    public bool updateStatics = true;
    public Color waterColor = Color.blue;

    [Header("Wave A")]

    public float waveLengthA = 1.0f;
    public Vector4 waveDirectionA = new Vector2(1.0f, 0.0f);
    [Range(0, 1)]
    public float steepnessA = 1.0f;

    [Header("Wave B")]
    public float waveLengthB = 1.0f;
    public Vector4 waveDirectionB = new Vector2(1.0f, 0.0f);
    [Range(0, 1)]
    public float steepnessB = 1.0f;

    [Header("Wave C")]
    public float waveLengthC = 1.0f;
    public Vector4 waveDirectionC = new Vector2(1.0f, 0.0f);
    [Range(0, 1)]
    public float steepnessC = 1.0f;

    private Material waterMaterial;

    private void Start()
    {
        waterMaterial = gameObject.GetComponent<MeshRenderer>().sharedMaterial;

        Vector4 waveA = new Vector4(waveDirectionA.x, waveDirectionA.y, steepnessA, waveLengthA);
        Vector4 waveB = new Vector4(waveDirectionB.x, waveDirectionB.y, steepnessB, waveLengthB);
        Vector4 waveC = new Vector4(waveDirectionC.x, waveDirectionC.y, steepnessC, waveLengthC);

        waterMaterial.SetVector("_WaveA", waveA);
        waterMaterial.SetVector("_WaveB", waveB);
        waterMaterial.SetVector("_WaveC", waveC);
        waterMaterial.SetColor("_WaterColor", waterColor);
    }

    private void Update()
    {
        if (updateStatics)
        {
            Vector4 waveA = new Vector4(waveDirectionA.x, waveDirectionA.y, steepnessA, waveLengthA);
            Vector4 waveB = new Vector4(waveDirectionB.x, waveDirectionB.y, steepnessB, waveLengthB);
            Vector4 waveC = new Vector4(waveDirectionC.x, waveDirectionC.y, steepnessC, waveLengthC);

            waterMaterial.SetVector("_WaveA", waveA);
            waterMaterial.SetVector("_WaveB", waveB);
            waterMaterial.SetVector("_WaveC", waveC);
            waterMaterial.SetColor("_WaterColor", waterColor);
        }
    }
}
