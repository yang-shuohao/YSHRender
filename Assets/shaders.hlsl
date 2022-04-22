
Texture2D t1 : register(t0);
SamplerState s1 : register(s0);

cbuffer SceneConstantBuffer : register(b0)
{
    float4x4 WorldViewProj;
}

struct PSInput
{
    float4 position : SV_POSITION;
    float2 texCoord : TEXCOORD;
};

PSInput VSMain(float4 position : POSITION, float2 texCoord : TEXCOORD)
{
    PSInput result;

    result.position = mul(position,WorldViewProj);
    result.texCoord = texCoord;

    return result;
}

float4 PSMain(PSInput input) : SV_TARGET
{
    return t1.Sample(s1, input.texCoord);
}
