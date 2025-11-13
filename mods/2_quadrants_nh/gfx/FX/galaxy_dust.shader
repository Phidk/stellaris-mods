Includes = {
	"constants.fxh"
	"terra_incognita.fxh"
}

PixelShader =
{
	Samplers = 
	{
		DustTexture = 
		{
			Index = 0;
			MagFilter = "Linear";
			MinFilter = "Linear";
			AddressU = "Wrap";
			AddressV = "Wrap";
		}
		
		ColorTexture = 
		{
			Index = 1;
			MagFilter = "Linear";
			MinFilter = "Linear";
			AddressU = "Clamp";
			AddressV = "Clamp";
		}	
		
		TerraIncognitaTexture = 
		{
			Index = 2;
			MagFilter = "Linear";
			MinFilter = "Linear";
			AddressU = "Clamp"
			AddressV = "Clamp"
		}
		
		Border = {
			Index = 3;
			MagFilter = "Linear";
			MinFilter = "Linear";
			MipFilter = "none";
			AddressU = "Wrap";
			AddressV = "Wrap";
		}
	}
}

VertexStruct VS_INPUT
{
    float2 vPosition  		: POSITION;
	float2 vUV				: TEXCOORD0;
	float3 vPos				: TEXCOORD1;
	float2 vSize_vRot		: TEXCOORD2;
};

VertexStruct VS_OUTPUT
{
    float4 vPosition 	: PDX_POSITION;
	float2 vUV			: TEXCOORD0;
	float2 vUVColor		: TEXCOORD1;
	float4 vPos			: TEXCOORD2;
	float4 vScreenCoord : TEXCOORD3;
};

ConstantBuffer( Common, 0, 0 )
{
	float4x4 	ViewProjectionMatrix;
	float4		DustCloudUV;
	float2		vResolution;
	float		TimeRot;
};

VertexShader =
{
	MainCode VertexShader
		ConstantBuffers = { Common }
	[[
		VS_OUTPUT main(const VS_INPUT v )
		{
			VS_OUTPUT Out;
			//float4 vPos = float4( v.vPosition.x, 0.f, v.vPosition.y, 1.f );		

			//--v.vPosition.{x,y} are the size of the sprite
			//--4th value seems to make area covered larger/smaller
			//float4 vPos = float4( v.vPosition.x / 10.f, 0.f, v.vPosition.y / 10.f, 1.f );	
			//float4 vPos = float4( v.vPosition.x * 10.f, 0.f, v.vPosition.y * 10.f, 1.f );	

			//--This is a compromise, twice as large to smooth the transitions, but more overlay so still slighty reduced performance
			float4 vPos = float4( v.vPosition.x * 2.f, 0.f, v.vPosition.y * 2.f, 1.f );
			
			//--Still not 100% on what this is doing
			vPos.xz *= v.vSize_vRot.x;
			
			//--Remove the rotation
			//float vTimeRot = TimeRot * ( -saturate( -v.vSize_vRot.y * 1000.0f ) + saturate( v.vSize_vRot.y * 1000.0f ) );
			//float randSin = sin( v.vSize_vRot.y + vTimeRot );
			//float randCos = cos( v.vSize_vRot.y + vTimeRot );
			//vPos.xz = float2( 
			//	vPos.x * randCos - vPos.z * randSin, 
			//	vPos.x * randSin + vPos.z * randCos );		
			
			//--Added to make the billboard tests work - not using billboards but was worth looking at
			//float3 Up = float3( 0.f, 1.f, 0.f );
			//float3 Right = float3( 1.f, 0.f, 0.f );
			
			//Semi-billboard
			//float3 Forward = cross( Right, Up );
			//vPos.y = dot( vPos, Forward ) * 0.3;
			
			//Real billboard
			//vPos.xyz = Right * vPos.x + Up * vPos.z;
			
			//--Remove tilt, we don't want any tilt
			//Tilt
			//vPos.y = ( v.vPosition.x + v.vPosition.y ) * v.vSize_vRot.x * 0.1f;
			
			//--Moves the particle to the position of each star
			//--Remove to get all particles at center of the map - this TANKS performance (alpha overlaps?)
			vPos.xyz += v.vPos;
			vPos.y = 0.f; //--Set all particles on the same plane (haven't seen any flutter issues)
			
			float4 vPosition = mul( ViewProjectionMatrix, vPos );
			Out.vPos 		= vPos;
			Out.vPosition  	= vPosition;
			Out.vUV			= v.vUV;
			Out.vUVColor 	= ( vPos.xz + DustCloudUV.xy ) / DustCloudUV.zw;
			
			Out.vScreenCoord.x = ( Out.vPosition.x * 0.5 + Out.vPosition.w * 0.5 );
			Out.vScreenCoord.y = ( Out.vPosition.w * 0.5 - Out.vPosition.y * 0.5 );
		#ifdef PDX_OPENGL
			Out.vScreenCoord.y = -Out.vScreenCoord.y;
		#endif	
			Out.vScreenCoord.z = Out.vPosition.w;
			Out.vScreenCoord.w = Out.vPosition.w;	
	
			return Out;
		}
		
	]]
}

PixelShader =
{
	MainCode PixelShader
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{	
			float4 vDiffuse = tex2D( DustTexture, v.vUV );
			
			float4 vColor = tex2D( ColorTexture, v.vUVColor );

			float4 vBorderColor = tex2Dproj( Border, v.vScreenCoord );
			
			//vBorderColor.a = saturate( vBorderColor.a * 0.8f );
			//vColor.rgb = lerp( vColor.rgb, vBorderColor.rgb * 1.f, vBorderColor.a );
			
			//-- Flat color, not too saturated
			vColor.rgb = vBorderColor.rgb * 1.5f;

			//float vTI = CalcTerraIncognitaValue( v.vPos.xz, TerraIncognitaTexture );
			//float vBorderTI = 0.80f; // Saturate border under TI
			//vTI = saturate( vTI + ( vBorderColor.a * vBorderTI ) * saturate( ( 1.0f - vTI ) * 1000 ) );
			//vColor = vDiffuse * lerp( vColor, vec4( TI_GRAY_BRIGHTNESS + vBorderColor.a * 0.3f  ), 1.0f - vTI );
			
			//-- Try applying just the diffuse (reduces opacity), contains the dust.dds texture
			vColor = vDiffuse * vColor;
			//vColor.a = 1.f;
			vColor.a *= 0.1f;

			return vColor;
		}
		
	]]
}

DepthStencilState DepthStencilState
{
	DepthEnable = no
}

BlendState BlendState
{
	BlendEnable = yes
	AlphaTest = no
	SourceBlend = "SRC_ALPHA"
	DestBlend = "INV_SRC_ALPHA"
}

RasterizerState RasterizerState
{
	FillMode = "FILL_SOLID"
	CullMode = "CULL_NONE"
	FrontCCW = no
}


Effect GalaxyDust
{
	VertexShader = "VertexShader";
	PixelShader = "PixelShader";
}
