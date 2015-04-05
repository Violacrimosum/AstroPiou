Shader "Hidden/Color3Blend3d" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
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
				#pragma exclude_renderers flash gles
				#include "Color3Common.cginc"

				uniform sampler3D _RgbTex3d;
				uniform sampler3D _LerpRgbTex3d;
				
				half4 frag( v2f i ) : COLOR
				{
					half4 color = tex2D( _MainTex, i.uv );
					
					half4 result = tex3D( _RgbTex3d, color.rgb * 0.96875 + 0.015625 );
					
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
				#pragma exclude_renderers flash gles
				#include "Color3Common.cginc"

				uniform sampler3D _RgbTex3d;
				uniform sampler3D _LerpRgbTex3d;
				
				half4 frag( v2f i ) : COLOR
				{
					half4 color = tex2D( _MainTex, i.uv );
					color.rgb = min( color.rgb, 1.0 ); // getting around the tex_sat d3d compiler bug, jfc...
					
					color.rgb = color.rgb * 0.96875 + 0.015625;
					half4 src = tex3D( _RgbTex3d, color.rgb );
					half4 dst = tex3D( _LerpRgbTex3d, color.rgb );
					
					return lerp( src, dst, _lerpAmount );
				}
			ENDCG
		}
	}

Fallback off
	
} // shader