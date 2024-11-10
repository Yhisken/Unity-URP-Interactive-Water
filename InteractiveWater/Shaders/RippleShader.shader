Shader "Unlit/RippleShader"
{
    Properties
    {
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            TEXTURE2D(_PrevRT);
            SAMPLER(sampler_PrevRT);
            TEXTURE2D(_CurrentRT);
            SAMPLER(sampler_CurrentRT);
            float4 _CurrentRT_TexelSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float3 e = float3(_CurrentRT_TexelSize.xy,0);
                float2 uv = i.uv;
                float speed = 1.0f;

                float p10 = SAMPLE_TEXTURE2D(_CurrentRT, sampler_CurrentRT, uv - e.zy * speed).r;
                float p01 = SAMPLE_TEXTURE2D(_CurrentRT, sampler_CurrentRT, uv - e.xz * speed).r;
                float p21 = SAMPLE_TEXTURE2D(_CurrentRT, sampler_CurrentRT, uv + e.xz * speed).r;
                float p12 = SAMPLE_TEXTURE2D(_CurrentRT, sampler_CurrentRT, uv + e.zy * speed).r;

                float p11 = SAMPLE_TEXTURE2D(_PrevRT, sampler_PrevRT, uv).r;

                float4 d = (p10 + p01 + p21 + p12)/2 - p11;
                d *= 0.99f;
                return d;
            }
            ENDHLSL
        }
    }
}
