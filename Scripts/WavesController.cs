using UnityEngine;

[ExecuteInEditMode]
public class WavesController : MonoBehaviour
{
    public bool updateStatics = true;

    public int iterations;

    [Header("Wave A")]

    public float waveLengthA = 1.0f;
    public Vector2 waveDirectionA = new Vector2(1.0f, 0.0f);
    [Range(0, 1)]
    public float steepnessA = 1.0f;

    public Vector2 directionDiff;
    public float steepnessDiff;
    public float waveLengthDiff;

    private Material waterMaterial;

    private void Start()
    {
        waterMaterial = gameObject.GetComponent<MeshRenderer>().sharedMaterial;

        Vector4 waveA = new Vector4(waveDirectionA.x, waveDirectionA.y, steepnessA, waveLengthA);

        waterMaterial.SetVector("_WaveA", waveA);
        waterMaterial.SetVector("_DirDiff", directionDiff);
        waterMaterial.SetFloat("_SteepDiff", steepnessDiff);
        waterMaterial.SetFloat("_LengthDiff", waveLengthDiff);
        waterMaterial.SetInt("_Iterations", iterations);
    }

    private void Update()
    {
        if (updateStatics)
        {
            waterMaterial = gameObject.GetComponent<MeshRenderer>().sharedMaterial;

            Vector4 waveA = new Vector4(waveDirectionA.x, waveDirectionA.y, steepnessA, waveLengthA);

            waterMaterial.SetVector("_WaveA", waveA);
            waterMaterial.SetVector("_DirDiff", directionDiff);
            waterMaterial.SetFloat("_SteepDiff", steepnessDiff);
            waterMaterial.SetFloat("_LengthDiff", waveLengthDiff);
            waterMaterial.SetInt("_Iterations", iterations);
        }
    }
}
