
cbuffer SceneConstantBuffer : register(b0)
{
    float4x4 MVP;
}

struct PSInput
{
    float4 position : SV_POSITION;
};

PSInput VSMain(float4 position : POSITION)
{
    PSInput result;

    result.position = mul(position, MVP);

    return result;
}

float4 PSMain(PSInput input) : SV_TARGET
{

    return float4(1.0f, 1.0f, 1.0f,1.0f);
}
