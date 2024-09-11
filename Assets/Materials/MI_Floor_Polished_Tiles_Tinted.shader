Shader "Unreal/MI_Floor_Polished_Tiles_tinted"
{
    Properties
    {
        _MainTex("MainTex (RGB)", 2D) = "white" {}
        _TintColor("Tint Color", Color) = (1, 1, 1, 1) // Añadimos la propiedad del color de tinte
        Material_Texture2D_0("L1NormalT", 2D) = "white" {}
        Material_Texture2D_1("MacroNormalT", 2D) = "white" {}
        Material_Texture2D_2("T_Dust_N", 2D) = "white" {}
        Material_Texture2D_3("World Aligned Mask", 2D) = "white" {}
        Material_Texture2D_4("T_Detal_Water_N", 2D) = "white" {}
        Material_Texture2D_5("L1AlbedoT", 2D) = "white" {}
        Material_Texture2D_6("T_Cloud_M", 2D) = "white" {}
        Material_Texture2D_7("L1MasksT", 2D) = "white" {}

        View_BufferSizeAndInvSize("View_BufferSizeAndInvSize", Vector) = (1920, 1080, 0.00052, 0.00092)
        LocalObjectBoundsMin("LocalObjectBoundsMin", Vector) = (0, 0, 0, 0)
        LocalObjectBoundsMax("LocalObjectBoundsMax", Vector) = (100, 100, 100, 0)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM

        #include "UnityPBSLighting.cginc"
        #pragma surface surf Standard vertex:vert addshadow

        #pragma target 5.0

        struct Input
        {
            float2 uv_MainTex : TEXCOORD0;
            float2 uv2_Material_Texture2D_0 : TEXCOORD1;
            float4 color : COLOR;
            float3 worldPos;
        };

        uniform sampler2D _MainTex;
        uniform float4 _TintColor; // Color de tinte

        void vert(inout appdata_full i, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            // Tomamos la textura principal (albedo)
            half4 baseTexture = tex2D(_MainTex, IN.uv_MainTex);

            // Aplicamos el tinte al albedo (mezclamos el color de la textura con el color de tinte)
            o.Albedo = baseTexture.rgb * _TintColor.rgb;

            // Mantener las demás propiedades como están
            o.Normal = normalize(o.Normal); // Dejar las normales como están
            o.Metallic = o.Metallic;        // Mantener la metalicidad
            o.Smoothness = o.Smoothness;    // Mantener la rugosidad
            o.Alpha = baseTexture.a;        // Mantener la transparencia si la textura la tiene
        }
        ENDCG
    }
    Fallback "Diffuse"
}
