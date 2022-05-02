
cbuffer SceneConstantBuffer : register(b0)
{
    float4x4 MVP;
    float4x4 Model;
    float3 AmbientDown;
    float3 AmbientUp;
}

float3 CalcAmbient(float3 normal, float3 color)
{

    float up = normal.y * 0.5 + 0.5;

    float3 Ambient = AmbientDown + mul(up, AmbientUp);

    return Ambient * color;
}

struct PSInput
{
    float4 position : SV_POSITION;
    float3 normal : NORMAL;
    float2 texcood : TEXCOORD;
};

PSInput VSMain(float4 position : POSITION, float3 normal : NORMAL, float2 texcoord : TEXCOORD)
{
    PSInput result;

    result.position = mul(position, MVP);
    result.normal = mul(float4(normal, 1.0f), Model);
    result.texcood = texcoord;
    
    return result;
}

float4 PSMain(PSInput input) : SV_TARGET
{

    float3 normal = normalize(input.normal);

    float4 color = float4(normal.rgb, 1.0f);

    return float4(CalcAmbient(normal, color.rgb), 1.0);
}
