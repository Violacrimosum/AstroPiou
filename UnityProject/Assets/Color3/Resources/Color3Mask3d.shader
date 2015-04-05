Shader "Hidden/Color3Mask3d" {
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
					half mask = tex2D( _MaskTex, i.uv1 ).r;

					half4 result = tex3D( _RgbTex3d, color.rgb * 0.96875 + 0.015625 );
					
					return lerp( color, result, mask );
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
					color.rgb = saturate( color.rgb );
					
					half mask = tex2D( _MaskTex, i.uv1 ).r;

					half4 result = tex3D( _RgbTex3d, color.rgb * 0.96875 + 0.015625 );
					
					return lerp( color, result, mask * ( 1 - _lerpAmount ) );
				}
			ENDCG
		}
	}

Fallback off
	
} // shader