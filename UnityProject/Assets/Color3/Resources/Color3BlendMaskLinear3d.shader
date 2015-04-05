Shader "Hidden/Color3BlendMaskLinear3d" {
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
					color.rgb = to_srgb( color.rgb );

					half mask = tex2D( _MaskTex, i.uv1 ).r;
					
					half4 result = tex3D( _RgbTex3d, color.rgb * 0.96875 + 0.015625 );
					result = lerp( color, result, mask );
					result.rgb = to_linear( result.rgb );

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
					color.rgb = to_srgb( color.rgb );
					
					half mask = tex2D( _MaskTex, i.uv1 ).r;

					color.rgb = color.rgb * 0.96875 + 0.015625;
					half4 src = tex3D( _RgbTex3d, color.rgb );
					half4 dst = tex3D( _LerpRgbTex3d, color.rgb );
					
					half4 result = lerp( src, dst, _lerpAmount );
					result = lerp( color, result, mask );
					result.rgb = to_linear( result.rgb );

					return result;
				}
			ENDCG
		}
	}

Fallback off
	
} // shader