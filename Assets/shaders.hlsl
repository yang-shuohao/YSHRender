
Texture2D t1 : register(t0);
SamplerState s1 : register(s0);

cbuffer SceneConstantBuffer : register(b0)
{
    float4x4 Model;
    float4x4 MVP;
    float3 lightColor;
    float3 lightPosition;
    float3 viewPosition;
}

struct PSInput
{
    float4 position : SV_POSITION;
    float2 texCoord : TEXCOORD;
    float3 normal : NORMAL;
    float4 worldPosition : POSITION;
};

PSInput VSMain(float4 position : POSITION, float3 normal : NORMAL, float2 texCoord : TEXCOORD)
{
    PSInput result;

    result.worldPosition = mul(position, Model);
    result.position = mul(position, MVP);
    result.texCoord = texCoord;
    result.normal = normal; //如果物体进行了非等比缩放，这里需要对法线进行模型矩阵左上角的逆矩阵的转置矩阵变换。

    return result;
}

float4 PSMain(PSInput input) : SV_TARGET
{
    float3 color = t1.Sample(s1, input.texCoord);
    //ambient
    float ambientStrength = 0.1;
    float3 ambient = mul(mul(ambientStrength, lightColor), color);
  	
    // diffuse 
    float3 norm = normalize(input.normal);
    float3 lightDir = normalize(lightPosition - viewPosition);
    float diff = max(dot(norm, lightDir), 0.0);
    float3 diffuse = mul(mul(diff, lightColor), color);
    
    // specular
    float specularStrength = 0.5;
    float3 viewDir = normalize(viewPosition - input.worldPosition.xyz);
    //float3 reflectDir = reflect(-lightDir, norm);
    float3 H = normalize(lightDir + viewDir);
    float spec = pow(max(dot(H, norm), 0.0), 32);
    float3 specular = mul(mul(mul(specularStrength, spec), lightColor), color);
        
    float4 outcolor = float4((ambient + diffuse + specular),1.0);

    return outcolor;
}
