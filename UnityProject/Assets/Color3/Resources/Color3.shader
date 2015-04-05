Shader "Hidden/Color3" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	
	Subshader {
		ZTest Always Cull Off ZWrite Off Blend Off
		Fog { Mode off }
		
		// !HDR && !Blend
		Pass {
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "Color3Common.cginc"

				uniform sampler2D _RgbTex;
				uniform sampler2D _LerpRgbTex;
				
				half4 frag( v2f i ) : COLOR
				{
					const half4 coord_scale = half4( 0.0302734375, 0.96875, 31.0, 0.0 );
					const half4 coord_offset = half4( 0.00048828125, 0.015625, 0.0, 0.0 );
					const half2 texel_height_X0 = half2( 0.03125, 0.0 );

					half4 color = tex2D( _MainTex, i.uv );

					half4 coord = color * coord_scale + coord_offset;
					half4 coord_frac = frac( coord );
					half4 coord_floor = coord - coord_frac;
					
					half2 coord_bot = coord.xy + coord_floor.zz * texel_height_X0;
					half2 coord_top = coord_bot + texel_height_X0;
					
					half4 lutcol_bot = tex2D( _RgbTex, coord_bot );
					half4 lutcol_top = tex2D( _RgbTex, coord_top );
					
					half4 result = lerp( lutcol_bot, lutcol_top, coord_frac.z );
					
					return result;
				}
			ENDCG
		}
	
		// HDR || Blend
		Pass {
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "Color3Common.cginc"

				uniform sampler2D _RgbTex;
				uniform sampler2D _LerpRgbTex;
				
				half4 frag( v2f i ) : COLOR
				{
					const half4 coord_scale = half4( 0.0302734375, 0.96875, 31.0, 0.0 );
					const half4 coord_offset = half4( 0.00048828125, 0.015625, 0.0, 0.0 );
					const half2 texel_height_X0 = half2( 0.03125, 0.0 );

					half4 color = tex2D( _MainTex, i.uv );
					color.rgb = saturate( color.rgb );

					half4 coord = color * coord_scale + coord_offset;
					half4 coord_frac = frac( coord );
					half4 coord_floor = coord - coord_frac;
					
					half2 coord_bot = coord.xy + coord_floor.zz * texel_height_X0;
					half2 coord_top = coord_bot + texel_height_X0;
					
					half4 lutcol_bot = tex2D( _RgbTex, coord_bot );
					half4 lutcol_top = tex2D( _RgbTex, coord_top );
					
					half4 result = lerp( lutcol_bot, lutcol_top, coord_frac.z );
					
					return lerp( result, color, _lerpAmount );
				}
			ENDCG
		}
	}

Fallback off
	
} // shader