Shader "Unreal/MI_Stair_Steps1"
{
	Properties
	{
		_MainTex("MainTex (RGB)", 2D) = "white" {}
		Material_Texture2D_0( "L1NormalT", 2D ) = "white" {}
		Material_Texture2D_1( "L2NormalT", 2D ) = "white" {}
		Material_Texture2D_2( "DamageNormalT", 2D ) = "white" {}
		Material_Texture2D_3( "World Aligned Mask", 2D ) = "white" {}
		Material_Texture2D_4( "T_Dust_N", 2D ) = "white" {}
		Material_Texture2D_5( "L1AlbedoT", 2D ) = "white" {}
		Material_Texture2D_6( "L2AlbedoT", 2D ) = "white" {}
		Material_Texture2D_7( "T_Cloud_M", 2D ) = "white" {}
		Material_Texture2D_8( "L2MasksT", 2D ) = "white" {}

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
			uniform sampler2D    Material_Texture2D_8;
			uniform SamplerState Material_Texture2D_8Sampler;
			
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
			float4 PreshaderBuffer[22];
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
	Material.PreshaderBuffer[1] = float4(2.000000,1.000000,1.000000,1500.000000);//(Unknown)
	Material.PreshaderBuffer[2] = float4(1500.000000,-1500.000000,-0.000667,1.500000);//(Unknown)
	Material.PreshaderBuffer[3] = float4(2.000000,0.400000,3.000000,0.500000);//(Unknown)
	Material.PreshaderBuffer[4] = float4(48.787769,-20.000000,-68.787766,-0.014537);//(Unknown)
	Material.PreshaderBuffer[5] = float4(0.500000,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[6] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[7] = float4(0.458333,0.458333,0.458333,1.000000);//(Unknown)
	Material.PreshaderBuffer[8] = float4(0.458333,0.458333,0.458333,5.000000);//(Unknown)
	Material.PreshaderBuffer[9] = float4(0.000000,1.000000,1.550000,0.700000);//(Unknown)
	Material.PreshaderBuffer[10] = float4(1.000000,1.000000,1.000000,1.000000);//(Unknown)
	Material.PreshaderBuffer[11] = float4(1.000000,1.000000,1.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[12] = float4(0.427083,0.427083,0.427083,1.000000);//(Unknown)
	Material.PreshaderBuffer[13] = float4(0.427083,0.427083,0.427083,0.000000);//(Unknown)
	Material.PreshaderBuffer[14] = float4(0.036458,0.036458,0.036458,1.000000);//(Unknown)
	Material.PreshaderBuffer[15] = float4(43.857510,609.033203,565.175720,0.001769);//(Unknown)
	Material.PreshaderBuffer[16] = float4(3.000000,0.200000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[17] = float4(0.036458,0.036458,0.036458,0.000000);//(Unknown)
	Material.PreshaderBuffer[18] = float4(0.067708,0.065410,0.054704,1.000000);//(Unknown)
	Material.PreshaderBuffer[19] = float4(0.067708,0.065410,0.054704,0.200000);//(Unknown)
	Material.PreshaderBuffer[20] = float4(0.267708,0.265410,0.254704,0.000000);//(Unknown)
	Material.PreshaderBuffer[21] = float4(0.750000,0.800000,0.850000,1.000000);//(Unknown)
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
	MaterialFloat4 Local9 = Parameters.VertexColor;
	MaterialFloat Local10 = DERIV_BASE_VALUE(Local9).r;
	MaterialFloat3 Local11 = lerp(Local3.rgb,Local7.rgb,DERIV_BASE_VALUE(Local10));
	MaterialFloat2 Local12 = (DERIV_BASE_VALUE(Local0) * ((MaterialFloat2)Material.PreshaderBuffer[1].z));
	MaterialFloat Local13 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local12), 6);
	MaterialFloat4 Local14 = UnpackNormalMap(Texture2DSampleBias(Material_Texture2D_2,Material_Texture2D_2Sampler,DERIV_BASE_VALUE(Local12),View.MaterialTextureMipBias));
	MaterialFloat Local15 = MaterialStoreTexSample(Parameters, Local14, 6);
	FLWCVector3 Local16 = GetWorldPosition_NoMaterialOffsets(Parameters);
	FLWCVector3 Local17 = LWCMultiply(DERIV_BASE_VALUE(Local16), LWCPromote(((MaterialFloat3)Material.PreshaderBuffer[2].z)));
	FLWCVector2 Local18 = MakeLWCVector(LWCGetX(DERIV_BASE_VALUE(Local17)), LWCGetZ(DERIV_BASE_VALUE(Local17)));
	MaterialFloat2 Local19 = LWCApplyAddressMode(DERIV_BASE_VALUE(Local18), LWCADDRESSMODE_WRAP, LWCADDRESSMODE_WRAP);
	MaterialFloat Local20 = MaterialStoreTexCoordScale(Parameters, Local19, 15);
	MaterialFloat4 Local21 = Texture2DSample(Material_Texture2D_3,GetMaterialSharedSampler(Material_Texture2D_3Sampler,View.MaterialTextureBilinearWrapedSampler),Local19);
	MaterialFloat Local22 = MaterialStoreTexSample(Parameters, Local21, 15);
	FLWCVector2 Local23 = MakeLWCVector(LWCGetY(DERIV_BASE_VALUE(Local17)), LWCGetZ(DERIV_BASE_VALUE(Local17)));
	MaterialFloat2 Local24 = LWCApplyAddressMode(DERIV_BASE_VALUE(Local23), LWCADDRESSMODE_WRAP, LWCADDRESSMODE_WRAP);
	MaterialFloat Local25 = MaterialStoreTexCoordScale(Parameters, Local24, 15);
	MaterialFloat4 Local26 = Texture2DSample(Material_Texture2D_3,GetMaterialSharedSampler(Material_Texture2D_3Sampler,View.MaterialTextureBilinearWrapedSampler),Local24);
	MaterialFloat Local27 = MaterialStoreTexSample(Parameters, Local26, 15);
	MaterialFloat Local28 = abs(Parameters.TangentToWorld[2].r);
	MaterialFloat Local29 = lerp((0.00000000 - 1.00000000),(1.00000000 + 1.00000000),Local28);
	MaterialFloat Local30 = saturate(Local29);
	MaterialFloat4 Local31 = lerp(MaterialFloat4(Local21.rgb,Local21.a),MaterialFloat4(Local26.rgb,Local26.a),Local30.r.r);
	FLWCVector2 Local32 = MakeLWCVector(LWCGetX(DERIV_BASE_VALUE(Local17)), LWCGetY(DERIV_BASE_VALUE(Local17)));
	MaterialFloat2 Local33 = LWCApplyAddressMode(DERIV_BASE_VALUE(Local32), LWCADDRESSMODE_WRAP, LWCADDRESSMODE_WRAP);
	MaterialFloat Local34 = MaterialStoreTexCoordScale(Parameters, Local33, 15);
	MaterialFloat4 Local35 = Texture2DSample(Material_Texture2D_3,GetMaterialSharedSampler(Material_Texture2D_3Sampler,View.MaterialTextureBilinearWrapedSampler),Local33);
	MaterialFloat Local36 = MaterialStoreTexSample(Parameters, Local35, 15);
	MaterialFloat Local37 = abs(Parameters.TangentToWorld[2].b);
	MaterialFloat Local38 = lerp((0.00000000 - 1.00000000),(1.00000000 + 1.00000000),Local37);
	MaterialFloat Local39 = saturate(Local38);
	MaterialFloat4 Local40 = lerp(Local31,MaterialFloat4(Local35.rgb,Local35.a),Local39.r.r);
	MaterialFloat4 Local41 = (Local40 * ((MaterialFloat4)Material.PreshaderBuffer[2].w));
	MaterialFloat4 Local42 = PositiveClampedPow(Local41,((MaterialFloat4)Material.PreshaderBuffer[3].x));
	MaterialFloat4 Local43 = saturate(Local42);
	MaterialFloat Local44 = (Material.PreshaderBuffer[3].y * Local43.g);
	MaterialFloat Local45 = saturate(Local44);
	MaterialFloat Local46 = DERIV_BASE_VALUE(Local9).g;
	MaterialFloat Local47 = (DERIV_BASE_VALUE(Local10) + DERIV_BASE_VALUE(Local46));
	MaterialFloat Local48 = (1.00000000 - DERIV_BASE_VALUE(Local47));
	MaterialFloat Local49 = (DERIV_BASE_VALUE(Local48) + DERIV_BASE_VALUE(Local46));
	MaterialFloat Local50 = lerp(0.00000000,Local45,DERIV_BASE_VALUE(Local49));
	MaterialFloat3 Local51 = lerp(Local11,Local14.rgb,Local50);
	MaterialFloat2 Local52 = (DERIV_BASE_VALUE(Local0) * ((MaterialFloat2)Material.PreshaderBuffer[3].z));
	MaterialFloat Local53 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local52), 10);
	MaterialFloat4 Local54 = UnpackNormalMap(Texture2DSampleBias(Material_Texture2D_4,Material_Texture2D_4Sampler,DERIV_BASE_VALUE(Local52),View.MaterialTextureMipBias));
	MaterialFloat Local55 = MaterialStoreTexSample(Parameters, Local54, 10);
	MaterialFloat3 Local56 = lerp(Local54.rgb,MaterialFloat3(0.00000000,0.00000000,1.00000000),Material.PreshaderBuffer[3].w);
	FLWCVector3 Local57 = LWCSubtract(DERIV_BASE_VALUE(Local16), GetActorWorldPosition(Parameters));
	MaterialFloat3 Local58 = LWCToFloat(DERIV_BASE_VALUE(Local57));
	MaterialFloat Local59 = DERIV_BASE_VALUE(Local58).b;
	MaterialFloat Local60 = (DERIV_BASE_VALUE(Local59) - Material.PreshaderBuffer[4].x);
	MaterialFloat Local61 = (DERIV_BASE_VALUE(Local60) * Material.PreshaderBuffer[4].w);
	MaterialFloat Local62 = saturate(DERIV_BASE_VALUE(Local61));
	MaterialFloat Local63 = PositiveClampedPow(Local43.b,Material.PreshaderBuffer[5].x);
	MaterialFloat Local64 = (DERIV_BASE_VALUE(Local62) * Local63);
	MaterialFloat Local65 = (0.00000000 + Local64);
	MaterialFloat Local66 = saturate(Local65);
	MaterialFloat3 Local67 = lerp(Local51,Local56,Local66);

	// The Normal is a special case as it might have its own expressions and also be used to calculate other inputs, so perform the assignment here
	PixelMaterialInputs.Normal = Local67.rgb;


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
	MaterialFloat3 Local68 = lerp(MaterialFloat3(0.00000000,0.00000000,0.00000000),Material.PreshaderBuffer[6].xyz,Material.PreshaderBuffer[5].y);
	MaterialFloat Local69 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local1), 0);
	MaterialFloat4 Local70 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_5,Material_Texture2D_5Sampler,DERIV_BASE_VALUE(Local1),View.MaterialTextureMipBias));
	MaterialFloat Local71 = MaterialStoreTexSample(Parameters, Local70, 0);
	MaterialFloat Local72 = dot(Local70.rgb,MaterialFloat3(0.30000001,0.58999997,0.11000000));
	MaterialFloat3 Local73 = (Material.PreshaderBuffer[8].xyz * ((MaterialFloat3)Local72));
	MaterialFloat3 Local74 = (Local73 + ((MaterialFloat3)0.20000000));
	MaterialFloat Local75 = (Local43.g * Material.PreshaderBuffer[8].w);
	MaterialFloat Local76 = max(Local75,Material.PreshaderBuffer[9].x);
	MaterialFloat Local77 = min(Local76,Material.PreshaderBuffer[9].y);
	MaterialFloat3 Local78 = abs(Parameters.TangentToWorld[2]);
	MaterialFloat3 Local79 = PositiveClampedPow(Local78,((MaterialFloat3)2.00000000));
	MaterialFloat Local80 = dot(Local79,((MaterialFloat3)Material.PreshaderBuffer[9].z));
	MaterialFloat Local81 = select((abs(Local80 - 1.50000000) > 0.00001000), select((Local80 >= 1.50000000), 0.00000000, 1.00000000), 0.00000000);
	MaterialFloat Local82 = (Local77 * Local81);
	MaterialFloat Local83 = PositiveClampedPow(Local82,Material.PreshaderBuffer[9].w);
	MaterialFloat Local84 = saturate(Local83);
	MaterialFloat3 Local85 = lerp(Local73,Local74,Local84);
	MaterialFloat Local86 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local5), 0);
	MaterialFloat4 Local87 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_6,Material_Texture2D_6Sampler,DERIV_BASE_VALUE(Local5),View.MaterialTextureMipBias));
	MaterialFloat Local88 = MaterialStoreTexSample(Parameters, Local87, 0);
	MaterialFloat Local89 = dot(Local87.rgb,MaterialFloat3(0.30000001,0.58999997,0.11000000));
	MaterialFloat3 Local90 = (Material.PreshaderBuffer[11].xyz * ((MaterialFloat3)Local89));
	MaterialFloat3 Local91 = lerp(Local85,Local90,DERIV_BASE_VALUE(Local10));
	MaterialFloat3 Local92 = (Material.PreshaderBuffer[13].xyz * Local91);
	MaterialFloat3 Local93 = lerp(Local91,Local92,Local50);
	MaterialFloat Local94 = (DERIV_BASE_VALUE(Local59) - Material.PreshaderBuffer[15].x);
	MaterialFloat Local95 = (DERIV_BASE_VALUE(Local94) * Material.PreshaderBuffer[15].w);
	MaterialFloat Local96 = saturate(DERIV_BASE_VALUE(Local95));
	MaterialFloat Local97 = PositiveClampedPow(Local43.b,Material.PreshaderBuffer[16].x);
	MaterialFloat Local98 = (DERIV_BASE_VALUE(Local96) * Local97);
	MaterialFloat Local99 = max(Local98,0.00000000);
	MaterialFloat Local100 = min(Local99,Material.PreshaderBuffer[16].y);
	MaterialFloat Local101 = dot(Parameters.TangentToWorld[2],MaterialFloat3(0.00000000,0.00000000,1.00000000));
	MaterialFloat Local102 = PositiveClampedPow(Local101,5.00000000);
	MaterialFloat Local103 = lerp(1.00000000,-1.00000000,Local102);
	MaterialFloat Local104 = saturate(Local103);
	MaterialFloat Local105 = (Local100 * Local104);
	MaterialFloat3 Local106 = lerp(Local93,Material.PreshaderBuffer[17].xyz,Local105);
	MaterialFloat Local107 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local52), 11);
	MaterialFloat4 Local108 = Texture2DSampleBias(Material_Texture2D_7,Material_Texture2D_7Sampler,DERIV_BASE_VALUE(Local52),View.MaterialTextureMipBias);
	MaterialFloat Local109 = MaterialStoreTexSample(Parameters, Local108, 11);
	MaterialFloat3 Local110 = lerp(Material.PreshaderBuffer[19].xyz,Material.PreshaderBuffer[20].xyz,Local108.g);
	MaterialFloat3 Local111 = lerp(Local106,Local110,Local66);
	MaterialFloat Local112 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local5), 1);
	MaterialFloat4 Local113 = Texture2DSampleBias(Material_Texture2D_8,Material_Texture2D_8Sampler,DERIV_BASE_VALUE(Local5),View.MaterialTextureMipBias);
	MaterialFloat Local114 = MaterialStoreTexSample(Parameters, Local113, 1);
	MaterialFloat Local115 = lerp(Material.PreshaderBuffer[20].w,Local113.r,DERIV_BASE_VALUE(Local10));
	MaterialFloat Local116 = lerp(Local115,0.00000000,Local66);
	MaterialFloat Local117 = lerp(Material.PreshaderBuffer[21].x,Material.PreshaderBuffer[21].y,Local84);
	MaterialFloat Local118 = lerp(Local117,Local113.g,DERIV_BASE_VALUE(Local10));
	MaterialFloat Local119 = lerp(Local118,Material.PreshaderBuffer[21].z,Local105);
	MaterialFloat Local120 = lerp(Local119,Material.PreshaderBuffer[21].w,Local66);
	MaterialFloat Local121 = lerp(1.00000000,Local113.b,DERIV_BASE_VALUE(Local10));
	MaterialFloat Local122 = lerp(Local121,1.00000000,Local66);

	PixelMaterialInputs.EmissiveColor = Local68;
	PixelMaterialInputs.Opacity = 1.00000000;
	PixelMaterialInputs.OpacityMask = 1.00000000;
	PixelMaterialInputs.BaseColor = Local111.rgb;
	PixelMaterialInputs.Metallic = Local116.r;
	PixelMaterialInputs.Specular = 0.50000000;
	PixelMaterialInputs.Roughness = Local120.r;
	PixelMaterialInputs.Anisotropy = 0.00000000;
	PixelMaterialInputs.Normal = Local67.rgb;
	PixelMaterialInputs.Tangent = MaterialFloat3(1.00000000,0.00000000,0.00000000);
	PixelMaterialInputs.Subsurface = 0;
	PixelMaterialInputs.AmbientOcclusion = Local122.r;
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