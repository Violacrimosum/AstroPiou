#include "UnityCG.cginc"

uniform sampler2D _MainTex;
uniform float4 _MainTex_TexelSize;
uniform sampler2D _MaskTex;
uniform half _lerpAmount;

struct v2f
{
	float4 pos : POSITION;
	float2 uv : TEXCOORD0;
	float2 uv1 : TEXCOORD1;
};

v2f vert( appdata_img v ) 
{
	v2f o;
	o.pos = mul( UNITY_MATRIX_MVP, v.vertex );
	o.uv = v.texcoord.xy;
	o.uv1 = v.texcoord.xy;
#if SHADER_API_D3D9 || SHADER_API_D3D11 || SHADER_API_D3D11_9X || SHADER_API_XBOX360
	if ( _MainTex_TexelSize.y < 0 )
		o.uv1.y = 1 - o.uv1.y;
#endif
	return o;
}

inline half3 to_srgb( in half3 c )
{
	return ( c.rgb < half3( 0.0031308, 0.0031308, 0.0031308 ) ) ? 12.92 * c.rgb : 1.055 * pow( c.rgb, 0.41666 ) - 0.055;
}

inline half3 to_linear( in half3 c )
{
	return ( c.rgb <= half3( 0.04045, 0.04045, 0.04045 ) ) ? c.rgb * ( 1.0 / 12.92 ) : pow( c.rgb * ( 1.0 / 1.055 ) + ( 0.055 / 1.055 ), 2.4 );
}