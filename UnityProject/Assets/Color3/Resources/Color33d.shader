Shader "Hidden/Color33d" {
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
					color.rgb = saturate( color.rgb );

					half4 result = tex3D( _RgbTex3d, color.rgb * 0.96875 + 0.015625 );
					
					return lerp( result, color, _lerpAmount );
				}
			ENDCG
		}
	}

Fallback off
	
} // shader