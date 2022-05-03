
cbuffer SceneConstantBuffer : register(b0)
{
    float4x4 MVP;
    float4x4 Model;
    float3 DirToLight;
    float3 DirLightColor;
    float3 EyePosition;
    float specExp;
    float3 diffuseColor;
    float specIntensity;
}

float3 CalcAmbient(float3 normal, float3 color)
{
    // Convert from [-1, 1] to [0, 1]
    float up = normal.y * 0.5 + 0.5;
    // Calculate the ambient value
    float3 AmbientDown = { 0.0f, 0.0f, 1.0f };
    float3 AmbientUp = { 0.0f, 1.0f, 0.0f };
    float3 Ambient = AmbientDown + up * AmbientUp;
    // Apply the ambient value to the color
    return Ambient * color;
}


float3 CalcDirectional(float3 position, float3 normal,float3 DirToLight, float3 DirLightColor, float3 EyePosition, float specExp, float3 diffuseColor, float specIntensity)
{
    // Phong diffuse
    float NDotL = dot(DirToLight, normal);
    float3 finalColor = DirLightColor.rgb * saturate(NDotL);
 
    // Blinn specular
    float3 ToEye = EyePosition.xyz - position;
    ToEye = normalize(ToEye);
    float3 HalfWay = normalize(ToEye + DirToLight);
    float NDotH = saturate(dot(HalfWay, normal));
    finalColor += DirLightColor.rgb * pow(NDotH, specExp) * specIntensity;
 
    return finalColor * diffuseColor.rgb;
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
    
    // Calculate the ambient color
    float4 finalColor;
    finalColor.rgb = CalcAmbient(input.normal, diffuseColor.rgb);
    // Calculate the directional light
    finalColor.rgb += CalcDirectional(input.position.xyz,input.normal,DirToLight,DirLightColor,EyePosition,specExp,diffuseColor,specIntensity);
    
    return finalColor;
}
