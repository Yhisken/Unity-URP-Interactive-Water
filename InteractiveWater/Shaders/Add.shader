Shader "Unlit/Add"
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

            TEXTURE2D(_ObjectsRT);
            SAMPLER(sampler_ObjectsRT);
            TEXTURE2D(_CurrentRT);
            SAMPLER(sampler_CurrentRT);
            float4 _ObjectsRT_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.uv = TRANSFORM_TEX(v.uv, _ObjectsRT);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float4 tex1 = SAMPLE_TEXTURE2D(_ObjectsRT, sampler_ObjectsRT,i.uv);
                float4 tex2 = SAMPLE_TEXTURE2D(_CurrentRT, sampler_ObjectsRT,i.uv);
                return tex1 + tex2;
            }
            ENDHLSL
        }
    }
}
