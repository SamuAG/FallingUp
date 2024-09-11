Shader "Unreal/MI_Glass_Dirty"
{
	Properties
	{
		_MainTex("MainTex (RGB)", 2D) = "white" {}
		Material_Texture2D_0( "RoughnessT", 2D ) = "white" {}
		Material_Texture2D_1( "T_Dripping_Dirt_M", 2D ) = "white" {}
		Material_Texture2D_2( "Good64x64TilingNoiseHighFreq", 2D ) = "white" {}

		View_BufferSizeAndInvSize( "View_BufferSizeAndInvSize", Vector ) = ( 1920,1080,0.00052, 0.00092 )//1920,1080,1/1920, 1/1080
		LocalObjectBoundsMin( "LocalObjectBoundsMin", Vector ) = ( 0, 0, 0, 0 )
		LocalObjectBoundsMax( "LocalObjectBoundsMax", Vector ) = ( 100, 100, 100, 0 )
	}
	SubShader 
	{
		//BLEND_OFF Tags { "RenderType" = "Opaque" }
		 Tags { "RenderType" = "Transparent"  "Queue" = "Transparent" }
		
		//Blend SrcAlpha OneMinusSrcAlpha
		//Cull Off

		CGPROGRAM

		#include "UnityPBSLighting.cginc"
		//BLEND_OFF #pragma surface surf Standard vertex:vert addshadow
		 #pragma surface surf Standard vertex:vert alpha:fade addshadow
		
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
			float4 PreshaderBuffer[15];
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
	Material.PreshaderBuffer[1] = float4(1.500000,0.200000,0.021000,0.985111);//(Unknown)
	Material.PreshaderBuffer[2] = float4(246.277756,246.277756,246.277756,0.000000);//(Unknown)
	Material.PreshaderBuffer[3] = float4(246.277756,246.277756,246.277756,0.000000);//(Unknown)
	Material.PreshaderBuffer[4] = float4(-246.277756,-246.277756,-246.277756,0.000000);//(Unknown)
	Material.PreshaderBuffer[5] = float4(-0.004060,-0.004060,-0.004060,0.150000);//(Unknown)
	Material.PreshaderBuffer[6] = float4(0.300000,0.100000,700.000000,0.001429);//(Unknown)
	Material.PreshaderBuffer[7] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[8] = float4(0.375000,0.375000,0.375000,1.000000);//(Unknown)
	Material.PreshaderBuffer[9] = float4(0.375000,0.375000,0.375000,0.000000);//(Unknown)
	Material.PreshaderBuffer[10] = float4(0.020833,0.019935,0.013715,1.000000);//(Unknown)
	Material.PreshaderBuffer[11] = float4(-0.028572,0.020833,0.019935,0.013715);//(Unknown)
	Material.PreshaderBuffer[12] = float4(1.000000,1.000000,1.500000,10.000000);//(Unknown)
	Material.PreshaderBuffer[13] = float4(-9.000000,0.500000,0.700000,0.500000);//(Unknown)
	Material.PreshaderBuffer[14] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
}
MaterialFloat3 CustomExpression0(FMaterialPixelParameters Parameters,MaterialFloat Distance,MaterialFloat DistanceSteps,MaterialFloat RadialSteps,MaterialFloat TempAARotation,MaterialFloat DistanceMask,Texture2D Tex, SamplerState TexSampler ,MaterialFloat TempAADistance,MaterialFloat RadialOffset)
{
float3 CurColor = 0;
float2 BaseUV = MaterialFloat2(ScreenAlignedPosition(Parameters.ScreenPosition).xy);
float2 NewUV = BaseUV;
float StepSize = Distance / (int) DistanceSteps;
float CurDistance = 0;
float2 CurOffset = 0;
float TwoPi = 6.283185;
float Substep = 0;
float2 ScenePixels=View_BufferSizeAndInvSize.xy*BaseUV;
ScenePixels+=View.TemporalAAParams.r;
float2 RandomSamp = ((uint)(ScenePixels.x) + 2 * (uint)(ScenePixels.y)) % 5;
RandomSamp+=Texture2DSample(Tex,TexSampler,ScenePixels);
RandomSamp/=5;
RandomSamp-=0.5;
TempAARotation*=RandomSamp;
TempAADistance*=StepSize*RandomSamp;


int i=0;
if (DistanceSteps<1)
{
return DecodeSceneColorForMaterialNode(NewUV);
}
else
{
//CurDistance += 0.5*StepSize;
LOOP
while ( i < (int) DistanceSteps)
{

//CurDistance+=StepSize;
for (int j = 0; j < (int) RadialSteps; j++)
{
CurOffset.x = cos(TwoPi*((TempAARotation+Substep) / RadialSteps));
CurOffset.y = sin(TwoPi*((TempAARotation+Substep) / RadialSteps));
CurOffset *=DistanceMask;
NewUV.x = BaseUV.x + (CurOffset.x * (CurDistance+(RandomSamp*TempAADistance)));
NewUV.y = BaseUV.y + (CurOffset.y * (CurDistance+(RandomSamp*TempAADistance)));
CurColor += DecodeSceneColorForMaterialNode(NewUV);
//CurDistance+=(StepSize+(TempAADistance))/RadialSteps;
Substep++;
}
CurDistance+=StepSize;
Substep+=RadialOffset;
i++;
}
CurColor = CurColor / ((int)DistanceSteps*(int)RadialSteps);
return CurColor;
}
}
void CalcPixelMaterialInputs(in out FMaterialPixelParameters Parameters, in out FPixelMaterialInputs PixelMaterialInputs)
{
	//WorldAligned texturing & others use normals & stuff that think Z is up
	Parameters.TangentToWorld[0] = Parameters.TangentToWorld[0].xzy;
	Parameters.TangentToWorld[1] = Parameters.TangentToWorld[1].xzy;
	Parameters.TangentToWorld[2] = Parameters.TangentToWorld[2].xzy;

	float3 WorldNormalCopy = Parameters.WorldNormal;

	// Initial calculations (required for Normal)
	MaterialFloat3 Local0 = (MaterialFloat3(0.00000000,0.00000000,1.00000000) * ((MaterialFloat3)Parameters.TwoSidedSign));

	// The Normal is a special case as it might have its own expressions and also be used to calculate other inputs, so perform the assignment here
	PixelMaterialInputs.Normal = Local0;


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
	MaterialFloat2 Local1 = Parameters.TexCoords[0].xy;
	MaterialFloat2 Local2 = (DERIV_BASE_VALUE(Local1) * ((MaterialFloat2)Material.PreshaderBuffer[1].x));
	MaterialFloat Local3 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local2), 0);
	MaterialFloat4 Local4 = Texture2DSampleBias(Material_Texture2D_0,Material_Texture2D_0Sampler,DERIV_BASE_VALUE(Local2),View.MaterialTextureMipBias);
	MaterialFloat Local5 = MaterialStoreTexSample(Parameters, Local4, 0);
	MaterialFloat Local6 = lerp(Material.PreshaderBuffer[1].z,Material.PreshaderBuffer[1].y,Local4.rgb.g);
	FLWCVector3 Local7 = GetWorldPosition(Parameters);
	FLWCVector3 Local8 = LWCAdd(GetObjectWorldPosition(Parameters), LWCPromote(((MaterialFloat3)float3(GetPrimitiveData(Parameters).ObjectBoundsX, GetPrimitiveData(Parameters).ObjectBoundsY, GetPrimitiveData(Parameters).ObjectBoundsZ).b)));
	FLWCVector3 Local9 = LWCSubtract(DERIV_BASE_VALUE(Local7), Local8);
	MaterialFloat3 Local10 = (LWCToFloat(Local9) * Material.PreshaderBuffer[5].xyz);
	MaterialFloat Local11 = MaterialStoreTexCoordScale(Parameters, Local10.rb, 1);
	MaterialFloat4 Local12 = Texture2DSampleBias(Material_Texture2D_1,Material_Texture2D_1Sampler,Local10.rb,View.MaterialTextureMipBias);
	MaterialFloat Local13 = MaterialStoreTexSample(Parameters, Local12, 1);
	MaterialFloat Local14 = MaterialStoreTexCoordScale(Parameters, Local10.gb, 1);
	MaterialFloat4 Local15 = Texture2DSampleBias(Material_Texture2D_1,Material_Texture2D_1Sampler,Local10.gb,View.MaterialTextureMipBias);
	MaterialFloat Local16 = MaterialStoreTexSample(Parameters, Local15, 1);
	MaterialFloat Local17 = abs(Parameters.TangentToWorld[2].r);
	MaterialFloat Local18 = lerp((0.00000000 - 2.00000000),(2.00000000 + 1.00000000),Local17);
	MaterialFloat Local19 = saturate(Local18);
	MaterialFloat Local20 = lerp(Local12.g,Local15.g,Local19.r.r);
	MaterialFloat Local21 = dot(Parameters.TangentToWorld[2],MaterialFloat3(0.00000000,0.00000000,1.00000000));
	MaterialFloat Local22 = PositiveClampedPow(Local21,5.00000000);
	MaterialFloat Local23 = lerp(1.00000000,-1.00000000,Local22);
	MaterialFloat Local24 = saturate(Local23);
	MaterialFloat Local25 = (Local20 * Local24);
	MaterialFloat Local26 = saturate(Local21);
	MaterialFloat Local27 = (Local25 + Local26);
	MaterialFloat Local28 = max(Local27,0.00000000);
	MaterialFloat Local29 = min(Local28,Material.PreshaderBuffer[5].w);
	MaterialFloat Local30 = lerp(Local6,Material.PreshaderBuffer[6].x,Local29);
	MaterialFloat Local31 = (Local30 * Material.PreshaderBuffer[6].y);
	MaterialFloat Local32 = CalcSceneDepth(ScreenAlignedPosition(GetScreenPosition(Parameters)));
	MaterialFloat Local33 = GetPixelDepth(Parameters);
	MaterialFloat Local34 = DERIV_BASE_VALUE(Local33).r;
	MaterialFloat Local35 = (Local32.r - DERIV_BASE_VALUE(Local34));
	MaterialFloat Local36 = (Local35 * Material.PreshaderBuffer[6].w);
	MaterialFloat Local37 = saturate(Local36);
	MaterialFloat3 Local38 = CustomExpression0(Parameters,Local31,4.00000000,8.00000000,1.00000000,Local37,Material_Texture2D_2,Material_Texture2D_2Sampler,1.00000000,0.61799997);
	MaterialFloat3 Local39 = saturate(Local38);
	MaterialFloat3 Local40 = lerp(Local39,Material.PreshaderBuffer[7].yzw,Material.PreshaderBuffer[7].x);
	MaterialFloat3 Local41 = lerp(Material.PreshaderBuffer[9].xyz,Material.PreshaderBuffer[11].yzw,Material.PreshaderBuffer[11].x);
	MaterialFloat Local42 = dot(Local0,Parameters.CameraVector);
	MaterialFloat Local43 = max(0.00000000,Local42);
	MaterialFloat Local44 = (1.00000000 - Local43);
	MaterialFloat Local45 = abs(Local44);
	MaterialFloat Local46 = max(Local45,0.00010000);
	MaterialFloat Local47 = PositiveClampedPow(Local46,Material.PreshaderBuffer[12].z);
	MaterialFloat Local48 = (Local47 * Material.PreshaderBuffer[13].x);
	MaterialFloat Local49 = (Local48 + Material.PreshaderBuffer[12].w);
	MaterialFloat Local50 = lerp(Material.PreshaderBuffer[13].z,Material.PreshaderBuffer[13].y,Local49);
	MaterialFloat Local51 = lerp(Material.PreshaderBuffer[13].w,Local50,Material.PreshaderBuffer[13].w);
	MaterialFloat Local52 = lerp(Local51,1.00000000,Local29);
	MaterialFloat3 Local53 = DecodeSceneColorForMaterialNode(ScreenAlignedPosition(GetScreenPosition(Parameters)));
	MaterialFloat3 Local54 = max(Local53,((MaterialFloat3)1.00000000));
	MaterialFloat3 Local55 = (((MaterialFloat3)Local52) + Local54);

	PixelMaterialInputs.EmissiveColor = Local40;
	PixelMaterialInputs.Opacity = Local55;
	PixelMaterialInputs.OpacityMask = 1.00000000;
	PixelMaterialInputs.BaseColor = Local41;
	PixelMaterialInputs.Metallic = Material.PreshaderBuffer[12].x;
	PixelMaterialInputs.Specular = Material.PreshaderBuffer[12].y;
	PixelMaterialInputs.Roughness = Local30;
	PixelMaterialInputs.Anisotropy = 0.00000000;
	PixelMaterialInputs.Normal = Local0;
	PixelMaterialInputs.Tangent = MaterialFloat3(1.00000000,0.00000000,0.00000000);
	PixelMaterialInputs.Subsurface = 0;
	PixelMaterialInputs.AmbientOcclusion = 1.00000000;
	PixelMaterialInputs.Refraction = MaterialFloat3(MaterialFloat3(1.00000000,0.00000000,0.00000000).xy,Material.PreshaderBuffer[14].x);
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