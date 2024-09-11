Shader "Unreal/MI_Floor_Polished_Tiles"
{
	Properties
	{
		_MainTex("MainTex (RGB)", 2D) = "white" {}
		Material_Texture2D_0( "L1NormalT", 2D ) = "white" {}
		Material_Texture2D_1( "MacroNormalT", 2D ) = "white" {}
		Material_Texture2D_2( "T_Dust_N", 2D ) = "white" {}
		Material_Texture2D_3( "World Aligned Mask", 2D ) = "white" {}
		Material_Texture2D_4( "T_Detal_Water_N", 2D ) = "white" {}
		Material_Texture2D_5( "L1AlbedoT", 2D ) = "white" {}
		Material_Texture2D_6( "T_Cloud_M", 2D ) = "white" {}
		Material_Texture2D_7( "L1MasksT", 2D ) = "white" {}

		View_BufferSizeAndInvSize( "View_BufferSizeAndInvSize", Vector ) = ( 1920,1080,0.00052, 0.00092 )//1920,1080,1/1920, 1/1080
		LocalObjectBoundsMin( "LocalObjectBoundsMin", Vector ) = ( 0, 0, 0, 0 )
		LocalObjectBoundsMax( "LocalObjectBoundsMax", Vector ) = ( 100, 100, 100, 0 )
	}
	SubShader 
	{
		 Tags { "RenderType" = "Opaque" }
		//BLEND_ON Tags { "RenderType" = "Transparent"  "Queue" = "Transparent" }
		
		//Blend SrcAlpha OneMinusSrcAlpha
		//Cull Off

		CGPROGRAM

		#include "UnityPBSLighting.cginc"
		 #pragma surface surf Standard vertex:vert addshadow
		//BLEND_ON #pragma surface surf Standard vertex:vert alpha:fade addshadow
		
		#pragma target 5.0

		#define NUM_TEX_COORD_INTERPOLATORS 1
		#define NUM_MATERIAL_TEXCOORDS_VERTEX 1
		#define NUM_CUSTOM_VERTEX_INTERPOLATORS 0

		struct Input
		{
			//float3 Normal;
			float2 uv_MainTex : TEXCOORD0;
			float2 uv2_Material_Texture2D_0 : TEXCOORD1;
			//float2 uv2_MainTex : TEXCOORD1;
			float4 color : COLOR;
			float4 tangent;
			//float4 normal;
			float3 viewDir;
			float4 screenPos;
			float3 worldPos;
			//float3 worldNormal;
			float3 normal2;
			INTERNAL_DATA
		};
		void vert( inout appdata_full i, out Input o )
		{
			float3 p_normal = mul( float4( i.normal, 0.0f ), unity_WorldToObject );
			//half4 p_tangent = mul( unity_ObjectToWorld,i.tangent );

			//half3 normal_input = normalize( p_normal.xyz );
			//half3 tangent_input = normalize( p_tangent.xyz );
			//half3 binormal_input = cross( p_normal.xyz,tangent_input.xyz ) * i.tangent.w;
			UNITY_INITIALIZE_OUTPUT( Input, o );

			//o.worldNormal = p_normal;
			o.normal2 = p_normal;
			o.tangent = i.tangent;
			//o.binormal_input = binormal_input;
		}
		uniform sampler2D _MainTex;
		/*
		struct SurfaceOutputStandard
		{
		fixed3 Albedo;		// base (diffuse or specular) color
		fixed3 Normal;		// tangent space normal, if written
		half3 Emission;
		half Metallic;		// 0=non-metal, 1=metal
		// Smoothness is the user facing name, it should be perceptual smoothness but user should not have to deal with it.
		// Everywhere in the code you meet smoothness it is perceptual smoothness
		half Smoothness;	// 0=rough, 1=smooth
		half Occlusion;		// occlusion (default 1)
		fixed Alpha;		// alpha for transparencies
		};
		*/


		#define Texture2D sampler2D
		#define TextureCube samplerCUBE
		#define SamplerState int

		#define UE5
		#define MATERIAL_TANGENTSPACENORMAL 1
		//struct Material
		//{
			//samplers start
			uniform sampler2D    Material_Texture2D_0;
			uniform SamplerState Material_Texture2D_0Sampler;
			uniform sampler2D    Material_Texture2D_1;
			uniform SamplerState Material_Texture2D_1Sampler;
			uniform sampler2D    Material_Texture2D_2;
			uniform SamplerState Material_Texture2D_2Sampler;
			uniform sampler2D    Material_Texture2D_3;
			uniform SamplerState Material_Texture2D_3Sampler;
			uniform sampler2D    Material_Texture2D_4;
			uniform SamplerState Material_Texture2D_4Sampler;
			uniform sampler2D    Material_Texture2D_5;
			uniform SamplerState Material_Texture2D_5Sampler;
			uniform sampler2D    Material_Texture2D_6;
			uniform SamplerState Material_Texture2D_6Sampler;
			uniform sampler2D    Material_Texture2D_7;
			uniform SamplerState Material_Texture2D_7Sampler;
			
		//};

		#ifdef UE5
			#define UE_LWC_RENDER_TILE_SIZE			2097152.0
			#define UE_LWC_RENDER_TILE_SIZE_SQRT	1448.15466
			#define UE_LWC_RENDER_TILE_SIZE_RSQRT	0.000690533954
			#define UE_LWC_RENDER_TILE_SIZE_RCP		4.76837158e-07
			#define UE_LWC_RENDER_TILE_SIZE_FMOD_PI		0.673652053
			#define UE_LWC_RENDER_TILE_SIZE_FMOD_2PI	0.673652053
			#define INVARIANT(X) X
			#define PI 					(3.1415926535897932)

			#include "LargeWorldCoordinates.hlsl"
		#endif
		struct MaterialStruct
		{
			float4 PreshaderBuffer[20];
			float4 ScalarExpressions[1];
			float VTPackedPageTableUniform[2];
			float VTPackedUniform[1];
		};
		struct ViewStruct
		{
			float GameTime;
			float RealTime;
			float DeltaTime;
			float PrevFrameGameTime;
			float PrevFrameRealTime;
			float MaterialTextureMipBias;
			SamplerState MaterialTextureBilinearWrapedSampler;
			SamplerState MaterialTextureBilinearClampedSampler;
			float4 PrimitiveSceneData[ 40 ];
			float4 TemporalAAParams;
			float2 ViewRectMin;
			float4 ViewSizeAndInvSize;
			float MaterialTextureDerivativeMultiply;
			uint StateFrameIndexMod8;
			float FrameNumber;
			float2 FieldOfViewWideAngles;
			float4 RuntimeVirtualTextureMipLevel;
			float PreExposure;
			float4 BufferBilinearUVMinMax;
		};
		struct ResolvedViewStruct
		{
		#ifdef UE5
			FLWCVector3 WorldCameraOrigin;
			FLWCVector3 PrevWorldCameraOrigin;
			FLWCVector3 PreViewTranslation;
			FLWCVector3 WorldViewOrigin;
		#else
			float3 WorldCameraOrigin;
			float3 PrevWorldCameraOrigin;
			float3 PreViewTranslation;
			float3 WorldViewOrigin;
		#endif
			float4 ScreenPositionScaleBias;
			float4x4 TranslatedWorldToView;
			float4x4 TranslatedWorldToCameraView;
			float4x4 TranslatedWorldToClip;
			float4x4 ViewToTranslatedWorld;
			float4x4 PrevViewToTranslatedWorld;
			float4x4 CameraViewToTranslatedWorld;
			float4 BufferBilinearUVMinMax;
			float4 XRPassthroughCameraUVs[ 2 ];
		};
		struct PrimitiveStruct
		{
			float4x4 WorldToLocal;
			float4x4 LocalToWorld;
		};

		ViewStruct View;
		ResolvedViewStruct ResolvedView;
		PrimitiveStruct Primitive;
		uniform float4 View_BufferSizeAndInvSize;
		uniform float4 LocalObjectBoundsMin;
		uniform float4 LocalObjectBoundsMax;
		uniform SamplerState Material_Wrap_WorldGroupSettings;
		uniform SamplerState Material_Clamp_WorldGroupSettings;
		
		#define PI UNITY_PI
		#include "UnrealCommon.cginc"

		MaterialStruct Material;
void InitializeExpressions()
{
	Material.PreshaderBuffer[0] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[1] = float4(2.000000,1.000000,0.000000,1.000000);//(Unknown)
	Material.PreshaderBuffer[2] = float4(0.500000,1.393286,0.696643,0.100000);//(Unknown)
	Material.PreshaderBuffer[3] = float4(-0.596643,1500.000000,1500.000000,-1500.000000);//(Unknown)
	Material.PreshaderBuffer[4] = float4(-0.000667,0.300000,0.300000,0.500000);//(Unknown)
	Material.PreshaderBuffer[5] = float4(1.000000,2.000000,1.715423,2.715423);//(Unknown)
	Material.PreshaderBuffer[6] = float4(-1.715423,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[7] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[8] = float4(0.348958,0.348958,0.348958,1.000000);//(Unknown)
	Material.PreshaderBuffer[9] = float4(0.348958,0.348958,0.348958,0.000000);//(Unknown)
	Material.PreshaderBuffer[10] = float4(0.317708,0.317708,0.317708,1.000000);//(Unknown)
	Material.PreshaderBuffer[11] = float4(0.317708,0.317708,0.317708,0.300000);//(Unknown)
	Material.PreshaderBuffer[12] = float4(0.052083,0.050315,0.042080,1.000000);//(Unknown)
	Material.PreshaderBuffer[13] = float4(0.052083,0.050315,0.042080,0.300000);//(Unknown)
	Material.PreshaderBuffer[14] = float4(0.352083,0.350315,0.342080,0.000000);//(Unknown)
	Material.PreshaderBuffer[15] = float4(0.015686,0.027451,0.027451,1.000000);//(Unknown)
	Material.PreshaderBuffer[16] = float4(0.500000,0.015686,0.027451,0.027451);//(Unknown)
	Material.PreshaderBuffer[17] = float4(0.200000,1500.000000,0.000667,3.000000);//(Unknown)
	Material.PreshaderBuffer[18] = float4(0.200000,0.300000,0.750000,1.000000);//(Unknown)
	Material.PreshaderBuffer[19] = float4(1.000000,0.010000,0.000000,0.000000);//(Unknown)
}void CalcPixelMaterialInputs(in out FMaterialPixelParameters Parameters, in out FPixelMaterialInputs PixelMaterialInputs)
{
	//WorldAligned texturing & others use normals & stuff that think Z is up
	Parameters.TangentToWorld[0] = Parameters.TangentToWorld[0].xzy;
	Parameters.TangentToWorld[1] = Parameters.TangentToWorld[1].xzy;
	Parameters.TangentToWorld[2] = Parameters.TangentToWorld[2].xzy;

	float3 WorldNormalCopy = Parameters.WorldNormal;

	// Initial calculations (required for Normal)
	MaterialFloat2 Local0 = Parameters.TexCoords[0].xy;
	MaterialFloat2 Local1 = (DERIV_BASE_VALUE(Local0) * ((MaterialFloat2)Material.PreshaderBuffer[1].x));
	MaterialFloat Local2 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local1), 2);
	MaterialFloat4 Local3 = UnpackNormalMap(Texture2DSampleBias(Material_Texture2D_0,Material_Texture2D_0Sampler,DERIV_BASE_VALUE(Local1),View.MaterialTextureMipBias));
	MaterialFloat Local4 = MaterialStoreTexSample(Parameters, Local3, 2);
	MaterialFloat2 Local5 = (DERIV_BASE_VALUE(Local0) * ((MaterialFloat2)Material.PreshaderBuffer[1].y));
	MaterialFloat Local6 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local5), 2);
	MaterialFloat4 Local7 = UnpackNormalMap(Texture2DSampleBias(Material_Texture2D_1,Material_Texture2D_1Sampler,DERIV_BASE_VALUE(Local5),View.MaterialTextureMipBias));
	MaterialFloat Local8 = MaterialStoreTexSample(Parameters, Local7, 2);
	MaterialFloat3 Local9 = lerp(Local7.rgb,MaterialFloat3(0.00000000,0.00000000,1.00000000),Material.PreshaderBuffer[1].z);
	MaterialFloat3 Local10 = (Local9 * MaterialFloat3(1.00000000,1.00000000,0.00000000));
	MaterialFloat3 Local11 = (Local3.rgb + Local10);
	MaterialFloat3 Local12 = normalize(Local11);
	MaterialFloat2 Local13 = (DERIV_BASE_VALUE(Local0) * ((MaterialFloat2)Material.PreshaderBuffer[1].w));
	MaterialFloat Local14 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local13), 10);
	MaterialFloat4 Local15 = UnpackNormalMap(Texture2DSampleBias(Material_Texture2D_2,Material_Texture2D_2Sampler,DERIV_BASE_VALUE(Local13),View.MaterialTextureMipBias));
	MaterialFloat Local16 = MaterialStoreTexSample(Parameters, Local15, 10);
	MaterialFloat3 Local17 = lerp(Local15.rgb,MaterialFloat3(0.00000000,0.00000000,1.00000000),Material.PreshaderBuffer[2].x);
	MaterialFloat3 Local18 = mul(Local12, Parameters.TangentToWorld);
	MaterialFloat3 Local19 = normalize(Local18);
	MaterialFloat Local20 = dot(Local19,normalize(MaterialFloat3(0.00000000,0.00000000,1.00000000)));
	MaterialFloat Local21 = (Local20 * 0.50000000);
	MaterialFloat Local22 = (Local21 + 0.50000000);
	MaterialFloat Local23 = (Local22 * Material.PreshaderBuffer[2].y);
	MaterialFloat Local24 = (Local23 + Material.PreshaderBuffer[3].x);
	MaterialFloat Local25 = saturate(Local24);
	FLWCVector3 Local26 = GetWorldPosition_NoMaterialOffsets(Parameters);
	FLWCVector3 Local27 = LWCMultiply(DERIV_BASE_VALUE(Local26), LWCPromote(((MaterialFloat3)Material.PreshaderBuffer[4].x)));
	FLWCVector2 Local28 = MakeLWCVector(LWCGetX(DERIV_BASE_VALUE(Local27)), LWCGetZ(DERIV_BASE_VALUE(Local27)));
	MaterialFloat2 Local29 = LWCApplyAddressMode(DERIV_BASE_VALUE(Local28), LWCADDRESSMODE_WRAP, LWCADDRESSMODE_WRAP);
	MaterialFloat Local30 = MaterialStoreTexCoordScale(Parameters, Local29, 15);
	MaterialFloat4 Local31 = Texture2DSample(Material_Texture2D_3,GetMaterialSharedSampler(Material_Texture2D_3Sampler,View.MaterialTextureBilinearWrapedSampler),Local29);
	MaterialFloat Local32 = MaterialStoreTexSample(Parameters, Local31, 15);
	FLWCVector2 Local33 = MakeLWCVector(LWCGetY(DERIV_BASE_VALUE(Local27)), LWCGetZ(DERIV_BASE_VALUE(Local27)));
	MaterialFloat2 Local34 = LWCApplyAddressMode(DERIV_BASE_VALUE(Local33), LWCADDRESSMODE_WRAP, LWCADDRESSMODE_WRAP);
	MaterialFloat Local35 = MaterialStoreTexCoordScale(Parameters, Local34, 15);
	MaterialFloat4 Local36 = Texture2DSample(Material_Texture2D_3,GetMaterialSharedSampler(Material_Texture2D_3Sampler,View.MaterialTextureBilinearWrapedSampler),Local34);
	MaterialFloat Local37 = MaterialStoreTexSample(Parameters, Local36, 15);
	MaterialFloat Local38 = abs(Parameters.TangentToWorld[2].r);
	MaterialFloat Local39 = lerp((0.00000000 - 1.00000000),(1.00000000 + 1.00000000),Local38);
	MaterialFloat Local40 = saturate(Local39);
	MaterialFloat4 Local41 = lerp(MaterialFloat4(Local31.rgb,Local31.a),MaterialFloat4(Local36.rgb,Local36.a),Local40.r.r);
	FLWCVector2 Local42 = MakeLWCVector(LWCGetX(DERIV_BASE_VALUE(Local27)), LWCGetY(DERIV_BASE_VALUE(Local27)));
	MaterialFloat2 Local43 = LWCApplyAddressMode(DERIV_BASE_VALUE(Local42), LWCADDRESSMODE_WRAP, LWCADDRESSMODE_WRAP);
	MaterialFloat Local44 = MaterialStoreTexCoordScale(Parameters, Local43, 15);
	MaterialFloat4 Local45 = Texture2DSample(Material_Texture2D_3,GetMaterialSharedSampler(Material_Texture2D_3Sampler,View.MaterialTextureBilinearWrapedSampler),Local43);
	MaterialFloat Local46 = MaterialStoreTexSample(Parameters, Local45, 15);
	MaterialFloat Local47 = abs(Parameters.TangentToWorld[2].b);
	MaterialFloat Local48 = lerp((0.00000000 - 1.00000000),(1.00000000 + 1.00000000),Local47);
	MaterialFloat Local49 = saturate(Local48);
	MaterialFloat4 Local50 = lerp(Local41,MaterialFloat4(Local45.rgb,Local45.a),Local49.r.r);
	MaterialFloat4 Local51 = (Local50 * ((MaterialFloat4)Material.PreshaderBuffer[4].y));
	MaterialFloat4 Local52 = PositiveClampedPow(Local51,((MaterialFloat4)Material.PreshaderBuffer[4].z));
	MaterialFloat4 Local53 = saturate(Local52);
	MaterialFloat Local54 = PositiveClampedPow(Local53.r,Material.PreshaderBuffer[4].w);
	MaterialFloat Local55 = saturate(Local54);
	MaterialFloat Local56 = (Local25 - Local55);
	MaterialFloat Local57 = saturate(Local56);
	MaterialFloat Local58 = saturate(Local57);
	MaterialFloat3 Local59 = lerp(Local12,Local17,Local58);
	MaterialFloat2 Local60 = (DERIV_BASE_VALUE(Local0) * ((MaterialFloat2)Material.PreshaderBuffer[5].y));
	MaterialFloat Local61 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local60), 9);
	MaterialFloat4 Local62 = UnpackNormalMap(Texture2DSampleBias(Material_Texture2D_4,Material_Texture2D_4Sampler,DERIV_BASE_VALUE(Local60),View.MaterialTextureMipBias));
	MaterialFloat Local63 = MaterialStoreTexSample(Parameters, Local62, 9);
	MaterialFloat Local64 = lerp(Material.PreshaderBuffer[6].x,Material.PreshaderBuffer[5].w,Local53.a);
	MaterialFloat Local65 = saturate(Local64);
	MaterialFloat Local66 = saturate(Local65.r);
	MaterialFloat Local67 = dot(Parameters.TangentToWorld[2],MaterialFloat3(0.00000000,0.00000000,1.00000000));
	MaterialFloat Local68 = PositiveClampedPow(Local67,5.00000000);
	MaterialFloat Local69 = lerp(-1.00000000,1.00000000,Local68);
	MaterialFloat Local70 = saturate(Local69);
	MaterialFloat Local71 = (Local66 * Local70);
	MaterialFloat3 Local72 = lerp(Local59,Local62.rgb,Local71);

	// The Normal is a special case as it might have its own expressions and also be used to calculate other inputs, so perform the assignment here
	PixelMaterialInputs.Normal = Local72.rgb;


#if TEMPLATE_USES_STRATA
	Parameters.StrataPixelFootprint = StrataGetPixelFootprint(Parameters.WorldPosition_CamRelative, GetRoughnessFromNormalCurvature(Parameters));
	Parameters.SharedLocalBases = StrataInitialiseSharedLocalBases();
	Parameters.StrataTree = GetInitialisedStrataTree();
#if STRATA_USE_FULLYSIMPLIFIED_MATERIAL == 1
	Parameters.SharedLocalBasesFullySimplified = StrataInitialiseSharedLocalBases();
	Parameters.StrataTreeFullySimplified = GetInitialisedStrataTree();
#endif
#endif

	// Note that here MaterialNormal can be in world space or tangent space
	float3 MaterialNormal = GetMaterialNormal(Parameters, PixelMaterialInputs);

#if MATERIAL_TANGENTSPACENORMAL

#if FEATURE_LEVEL >= FEATURE_LEVEL_SM4
	// Mobile will rely on only the final normalize for performance
	MaterialNormal = normalize(MaterialNormal);
#endif

	// normalizing after the tangent space to world space conversion improves quality with sheared bases (UV layout to WS causes shrearing)
	// use full precision normalize to avoid overflows
	Parameters.WorldNormal = TransformTangentNormalToWorld(Parameters.TangentToWorld, MaterialNormal);

#else //MATERIAL_TANGENTSPACENORMAL

	Parameters.WorldNormal = normalize(MaterialNormal);

#endif //MATERIAL_TANGENTSPACENORMAL

#if MATERIAL_TANGENTSPACENORMAL
	// flip the normal for backfaces being rendered with a two-sided material
	Parameters.WorldNormal *= Parameters.TwoSidedSign;
#endif

	Parameters.ReflectionVector = ReflectionAboutCustomWorldNormal(Parameters, Parameters.WorldNormal, false);

#if !PARTICLE_SPRITE_FACTORY
	Parameters.Particle.MotionBlurFade = 1.0f;
#endif // !PARTICLE_SPRITE_FACTORY

	// Now the rest of the inputs
	MaterialFloat3 Local73 = lerp(MaterialFloat3(0.00000000,0.00000000,0.00000000),Material.PreshaderBuffer[7].xyz,Material.PreshaderBuffer[6].y);
	MaterialFloat Local74 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local1), 0);
	MaterialFloat4 Local75 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_5,Material_Texture2D_5Sampler,DERIV_BASE_VALUE(Local1),View.MaterialTextureMipBias));
	MaterialFloat Local76 = MaterialStoreTexSample(Parameters, Local75, 0);
	MaterialFloat Local77 = dot(Local75.rgb,MaterialFloat3(0.30000001,0.58999997,0.11000000));
	MaterialFloat3 Local78 = (Material.PreshaderBuffer[9].xyz * ((MaterialFloat3)Local77));
	MaterialFloat3 Local79 = (Material.PreshaderBuffer[11].xyz * Local78);
	MaterialFloat Local80 = (Material.PreshaderBuffer[11].w * Local53.g);
	MaterialFloat Local81 = saturate(Local80);
	MaterialFloat4 Local82 = Parameters.VertexColor;
	MaterialFloat Local83 = DERIV_BASE_VALUE(Local82).r;
	MaterialFloat Local84 = DERIV_BASE_VALUE(Local82).g;
	MaterialFloat Local85 = (DERIV_BASE_VALUE(Local83) + DERIV_BASE_VALUE(Local84));
	MaterialFloat Local86 = (1.00000000 - DERIV_BASE_VALUE(Local85));
	MaterialFloat Local87 = (DERIV_BASE_VALUE(Local86) + DERIV_BASE_VALUE(Local83));
	MaterialFloat Local88 = (DERIV_BASE_VALUE(Local87) + DERIV_BASE_VALUE(Local84));
	MaterialFloat Local89 = lerp(0.00000000,Local81,DERIV_BASE_VALUE(Local88));
	MaterialFloat3 Local90 = lerp(Local78,Local79,Local89);
	MaterialFloat Local91 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local13), 11);
	MaterialFloat4 Local92 = Texture2DSampleBias(Material_Texture2D_6,Material_Texture2D_6Sampler,DERIV_BASE_VALUE(Local13),View.MaterialTextureMipBias);
	MaterialFloat Local93 = MaterialStoreTexSample(Parameters, Local92, 11);
	MaterialFloat3 Local94 = lerp(Material.PreshaderBuffer[13].xyz,Material.PreshaderBuffer[14].xyz,Local92.g);
	MaterialFloat3 Local95 = lerp(Local90,Local94,Local58);
	MaterialFloat3 Local96 = lerp(Local95,Material.PreshaderBuffer[16].yzw,Material.PreshaderBuffer[16].x);
	MaterialFloat3 Local97 = lerp(Local95,Local96,Local71);
	MaterialFloat Local98 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local1), 1);
	MaterialFloat4 Local99 = Texture2DSampleBias(Material_Texture2D_7,Material_Texture2D_7Sampler,DERIV_BASE_VALUE(Local1),View.MaterialTextureMipBias);
	MaterialFloat Local100 = MaterialStoreTexSample(Parameters, Local99, 1);
	MaterialFloat Local101 = lerp(Local99.r,0.00000000,Local58);
	MaterialFloat Local102 = lerp(Local101,0.00000000,Local71);
	MaterialFloat2 Local103 = (DERIV_BASE_VALUE(Local0) * ((MaterialFloat2)Material.PreshaderBuffer[17].x));
	MaterialFloat Local104 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local103), 1);
	MaterialFloat4 Local105 = Texture2DSampleBias(Material_Texture2D_7,Material_Texture2D_7Sampler,DERIV_BASE_VALUE(Local103),View.MaterialTextureMipBias);
	MaterialFloat Local106 = MaterialStoreTexSample(Parameters, Local105, 1);
	FLWCVector3 Local107 = GetWorldPosition(Parameters);
	FLWCVector3 Local108 = ResolvedView.WorldCameraOrigin;
	FLWCVector3 Local109 = LWCSubtract(DERIV_BASE_VALUE(Local107), Local108);
	MaterialFloat3 Local110 = LWCToFloat(DERIV_BASE_VALUE(Local109));
	MaterialFloat Local111 = length(DERIV_BASE_VALUE(Local110));
	MaterialFloat Local112 = (DERIV_BASE_VALUE(Local111) * Material.PreshaderBuffer[17].z);
	MaterialFloat Local113 = PositiveClampedPow(DERIV_BASE_VALUE(Local112),Material.PreshaderBuffer[17].w);
	MaterialFloat Local114 = saturate(DERIV_BASE_VALUE(Local113));
	MaterialFloat Local115 = lerp(Local99.g,Local105.g,DERIV_BASE_VALUE(Local114));
	MaterialFloat Local116 = max(Local115,Material.PreshaderBuffer[18].x);
	MaterialFloat Local117 = min(Local116,Material.PreshaderBuffer[18].y);
	MaterialFloat Local118 = max(Local117,Material.PreshaderBuffer[18].z);
	MaterialFloat Local119 = min(Local118,Material.PreshaderBuffer[18].w);
	MaterialFloat Local120 = lerp(Local117,Local119,Local89);
	MaterialFloat Local121 = lerp(Local120,Material.PreshaderBuffer[19].x,Local58);
	MaterialFloat Local122 = lerp(Local121,Material.PreshaderBuffer[19].y,Local71);
	MaterialFloat Local123 = lerp(Local99.b,1.00000000,Local58);
	MaterialFloat Local124 = lerp(Local123,1.00000000,Local71);

	PixelMaterialInputs.EmissiveColor = Local73;
	PixelMaterialInputs.Opacity = 1.00000000;
	PixelMaterialInputs.OpacityMask = 1.00000000;
	PixelMaterialInputs.BaseColor = Local97.rgb;
	PixelMaterialInputs.Metallic = Local102.r;
	PixelMaterialInputs.Specular = 0.50000000;
	PixelMaterialInputs.Roughness = Local122.r;
	PixelMaterialInputs.Anisotropy = 0.00000000;
	PixelMaterialInputs.Normal = Local72.rgb;
	PixelMaterialInputs.Tangent = MaterialFloat3(1.00000000,0.00000000,0.00000000);
	PixelMaterialInputs.Subsurface = 0;
	PixelMaterialInputs.AmbientOcclusion = Local124.r;
	PixelMaterialInputs.Refraction = 0;
	PixelMaterialInputs.PixelDepthOffset = 0.00000000;
	PixelMaterialInputs.ShadingModel = 1;
	PixelMaterialInputs.FrontMaterial = GetInitialisedStrataData();
	PixelMaterialInputs.SurfaceThickness = 0.01000000;
	PixelMaterialInputs.Displacement = 0.00000000;


#if MATERIAL_USES_ANISOTROPY
	Parameters.WorldTangent = CalculateAnisotropyTangent(Parameters, PixelMaterialInputs);
#else
	Parameters.WorldTangent = 0;
#endif
}
		void surf( Input In, inout SurfaceOutputStandard o )
		{
			InitializeExpressions();

			float3 Z3 = float3( 0, 0, 0 );
			float4 Z4 = float4( 0, 0, 0, 0 );

			float3 UnrealWorldPos = float3( In.worldPos.x, In.worldPos.y, In.worldPos.z );
			
			float3 UnrealNormal = In.normal2;

			FMaterialPixelParameters Parameters = (FMaterialPixelParameters)0;
			#if NUM_TEX_COORD_INTERPOLATORS > 0			
				Parameters.TexCoords[ 0 ] = float2( In.uv_MainTex.x, 1.0 - In.uv_MainTex.y );
			#endif
			#if NUM_TEX_COORD_INTERPOLATORS > 1
				Parameters.TexCoords[ 1 ] = float2( In.uv2_Material_Texture2D_0.x, 1.0 - In.uv2_Material_Texture2D_0.y );
			#endif
			#if NUM_TEX_COORD_INTERPOLATORS > 2
			for( int i = 2; i < NUM_TEX_COORD_INTERPOLATORS; i++ )
			{
				Parameters.TexCoords[ i ] = float2( In.uv_MainTex.x, 1.0 - In.uv_MainTex.y );
			}
			#endif
			Parameters.VertexColor = In.color;
			Parameters.WorldNormal = UnrealNormal;
			Parameters.ReflectionVector = half3( 0, 0, 1 );
			Parameters.CameraVector = normalize( _WorldSpaceCameraPos.xyz - UnrealWorldPos.xyz );
			//Parameters.CameraVector = mul( ( float3x3 )unity_CameraToWorld, float3( 0, 0, 1 ) ) * -1;
			Parameters.LightVector = half3( 0, 0, 0 );
			float4 screenpos = In.screenPos;
			screenpos /= screenpos.w;
			//screenpos.y = 1 - screenpos.y;
			Parameters.SvPosition = float4( screenpos.x, screenpos.y, 0, 0 );
			Parameters.ScreenPosition = Parameters.SvPosition;

			Parameters.UnMirrored = 1;

			Parameters.TwoSidedSign = 1;
			

			float3 InWorldNormal = UnrealNormal;
			float4 InTangent = In.tangent;
			float4 tangentWorld = float4( UnityObjectToWorldDir( InTangent.xyz ), InTangent.w );
			tangentWorld.xyz = normalize( tangentWorld.xyz );
			float3x3 OriginalTangentToWorld = CreateTangentToWorldPerVertex( InWorldNormal, tangentWorld.xyz, tangentWorld.w );
			Parameters.TangentToWorld = OriginalTangentToWorld;

			//WorldAlignedTexturing in UE relies on the fact that coords there are 100x larger, prepare values for that
			//but watch out for any computation that might get skewed as a side effect
			UnrealWorldPos = ToUnrealPos( UnrealWorldPos );
			
			Parameters.AbsoluteWorldPosition = UnrealWorldPos;
			Parameters.WorldPosition_CamRelative = UnrealWorldPos;
			Parameters.WorldPosition_NoOffsets = UnrealWorldPos;

			Parameters.WorldPosition_NoOffsets_CamRelative = Parameters.WorldPosition_CamRelative;
			Parameters.LightingPositionOffset = float3( 0, 0, 0 );

			Parameters.AOMaterialMask = 0;

			Parameters.Particle.RelativeTime = 0;
			Parameters.Particle.MotionBlurFade;
			Parameters.Particle.Random = 0;
			Parameters.Particle.Velocity = half4( 1, 1, 1, 1 );
			Parameters.Particle.Color = half4( 1, 1, 1, 1 );
			Parameters.Particle.TranslatedWorldPositionAndSize = float4( UnrealWorldPos, 0 );
			Parameters.Particle.MacroUV = half4(0,0,1,1);
			Parameters.Particle.DynamicParameter = half4(0,0,0,0);
			Parameters.Particle.LocalToWorld = float4x4( Z4, Z4, Z4, Z4 );
			Parameters.Particle.Size = float2(1,1);
			Parameters.Particle.SubUVCoords[ 0 ] = Parameters.Particle.SubUVCoords[ 1 ] = float2( 0, 0 );
			Parameters.Particle.SubUVLerp = 0.0;
			Parameters.TexCoordScalesParams = float2( 0, 0 );
			Parameters.PrimitiveId = 0;
			Parameters.VirtualTextureFeedback = 0;

			FPixelMaterialInputs PixelMaterialInputs = ( FPixelMaterialInputs)0;
			PixelMaterialInputs.Normal = float3( 0, 0, 1 );
			PixelMaterialInputs.ShadingModel = 0;
			PixelMaterialInputs.FrontMaterial = 0;

			View.GameTime = View.RealTime = _Time.y;// _Time is (t/20, t, t*2, t*3)
			View.PrevFrameGameTime = View.GameTime - unity_DeltaTime.x;//(dt, 1/dt, smoothDt, 1/smoothDt)
			View.PrevFrameRealTime = View.RealTime;
			View.DeltaTime = unity_DeltaTime.x;
			View.MaterialTextureMipBias = 0.0;
			View.TemporalAAParams = float4( 0, 0, 0, 0 );
			View.ViewRectMin = float2( 0, 0 );
			View.ViewSizeAndInvSize = View_BufferSizeAndInvSize;
			View.MaterialTextureDerivativeMultiply = 1.0f;
			View.StateFrameIndexMod8 = 0;
			View.FrameNumber = (int)_Time.y;
			View.FieldOfViewWideAngles = float2( PI * 0.42f, PI * 0.42f );//75degrees, default unity
			View.RuntimeVirtualTextureMipLevel = float4( 0, 0, 0, 0 );
			View.PreExposure = 0;
			View.BufferBilinearUVMinMax = float4(
				View_BufferSizeAndInvSize.z * ( 0 + 0.5 ),//EffectiveViewRect.Min.X
				View_BufferSizeAndInvSize.w * ( 0 + 0.5 ),//EffectiveViewRect.Min.Y
				View_BufferSizeAndInvSize.z * ( View_BufferSizeAndInvSize.x - 0.5 ),//EffectiveViewRect.Max.X
				View_BufferSizeAndInvSize.w * ( View_BufferSizeAndInvSize.y - 0.5 ) );//EffectiveViewRect.Max.Y

			for( int i2 = 0; i2 < 40; i2++ )
				View.PrimitiveSceneData[ i2 ] = float4( 0, 0, 0, 0 );

			float4x4 ViewMatrix = transpose( unity_MatrixV );
			float4x4 InverseViewMatrix = transpose( unity_MatrixInvV );
			float4x4 ViewProjectionMatrix = transpose( unity_MatrixVP );

			uint PrimitiveBaseOffset = Parameters.PrimitiveId * PRIMITIVE_SCENE_DATA_STRIDE;
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 0 ] = unity_ObjectToWorld[ 0 ];//LocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 1 ] = unity_ObjectToWorld[ 1 ];//LocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 2 ] = unity_ObjectToWorld[ 2 ];//LocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 3 ] = unity_ObjectToWorld[ 3 ];//LocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 6 ] = unity_WorldToObject[ 0 ];//WorldToLocal
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 7 ] = unity_WorldToObject[ 1 ];//WorldToLocal
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 8 ] = unity_WorldToObject[ 2 ];//WorldToLocal
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 9 ] = unity_WorldToObject[ 3 ];//WorldToLocal
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 10 ] = unity_WorldToObject[ 0 ];//PreviousLocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 11 ] = unity_WorldToObject[ 1 ];//PreviousLocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 12 ] = unity_WorldToObject[ 2 ];//PreviousLocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 13 ] = unity_WorldToObject[ 3 ];//PreviousLocalToWorld
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 18 ] = float4( ToUnrealPos( UNITY_MATRIX_M[ 3 ] ), 0 );//ActorWorldPosition
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 19 ] = LocalObjectBoundsMax - LocalObjectBoundsMin;//ObjectBounds
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 21 ] = mul( unity_ObjectToWorld, float3( 1, 0, 0 ) );//ObjectOrientation
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 23 ] = LocalObjectBoundsMin;//LocalObjectBoundsMin
			View.PrimitiveSceneData[ PrimitiveBaseOffset + 24 ] = LocalObjectBoundsMax;//LocalObjectBoundsMax

			#ifdef UE5
				ResolvedView.WorldCameraOrigin = LWCPromote( ToUnrealPos( _WorldSpaceCameraPos.xyz ) );
				ResolvedView.PreViewTranslation = LWCPromote( float3( 0, 0, 0 ) );
				ResolvedView.WorldViewOrigin = LWCPromote( float3( 0, 0, 0 ) );
			#else
				ResolvedView.WorldCameraOrigin = ToUnrealPos( _WorldSpaceCameraPos.xyz );
				ResolvedView.PreViewTranslation = float3( 0, 0, 0 );
				ResolvedView.WorldViewOrigin = float3( 0, 0, 0 );
			#endif
			ResolvedView.PrevWorldCameraOrigin = ResolvedView.WorldCameraOrigin;
			ResolvedView.ScreenPositionScaleBias = float4( 1, 1, 0, 0 );
			ResolvedView.TranslatedWorldToView = ViewMatrix;
			ResolvedView.TranslatedWorldToCameraView = ViewMatrix;
			ResolvedView.TranslatedWorldToClip = ViewProjectionMatrix;
			ResolvedView.ViewToTranslatedWorld = InverseViewMatrix;
			ResolvedView.PrevViewToTranslatedWorld = ResolvedView.ViewToTranslatedWorld;
			ResolvedView.CameraViewToTranslatedWorld = InverseViewMatrix;
			ResolvedView.BufferBilinearUVMinMax = View.BufferBilinearUVMinMax;
			ResolvedView.XRPassthroughCameraUVs[ 0 ] = ResolvedView.XRPassthroughCameraUVs[ 1 ] = float4( 0, 0, 1, 1 );
			Primitive.WorldToLocal = unity_WorldToObject;
			Primitive.LocalToWorld = unity_ObjectToWorld;
			CalcPixelMaterialInputs( Parameters, PixelMaterialInputs );

			#define HAS_WORLDSPACE_NORMAL 0
			#if HAS_WORLDSPACE_NORMAL
				PixelMaterialInputs.Normal = mul( PixelMaterialInputs.Normal, (MaterialFloat3x3)( transpose( OriginalTangentToWorld ) ) );
			#endif

			o.Albedo = PixelMaterialInputs.BaseColor.rgb;
			o.Alpha = PixelMaterialInputs.Opacity;
			//if( PixelMaterialInputs.OpacityMask < 0.333 ) discard;

			o.Metallic = PixelMaterialInputs.Metallic;
			o.Smoothness = 1.0 - PixelMaterialInputs.Roughness;
			o.Normal = normalize( PixelMaterialInputs.Normal );
			o.Emission = PixelMaterialInputs.EmissiveColor.rgb;
			o.Occlusion = PixelMaterialInputs.AmbientOcclusion;

			//BLEND_ADDITIVE o.Alpha = ( o.Emission.r + o.Emission.g + o.Emission.b ) / 3;
		}
		ENDCG
	}
	Fallback "Diffuse"
}