//Chromakeyer shader for Unity 3D, done by Eric Wenger ( http://www.metasynth.com/ERICWENGER/  ) in april 2014, Alpha version, shared by noomuseum.net   feel free to use.
// put a movie texture on a plane, choose the shader GLSL_Keyer in the material inspector. Choose the more light and dark background with the color picker,
// by picking the colors somewhere on your screen... and adjust the differents cursors... 




Shader "GLSL_Keyer" {
    Properties {
        _MainTex ("Base (RGBA)", 2D) = "white" {}
        _Color("Main Color", Color) = (0,1,0,1)
        _ColorB(" Color B", Color) = (0,0.8,0.1,1)
        _LumMin("Lum Min", Range (0, 0.5)) =0.1
        _LumMax("Lum Max", Range (0.5, 1.0)) =0.95
        _tolerence("tolerence", Range (0.0, 0.5)) =0.1
        _feather("feather", Range (-0.5, 0.5)) =0.1
    }
    
    SubShader {
        //Tags { "Queue" = "Geometry" }
        Tags { "Queue" = "Transparent" }
           Blend SrcAlpha OneMinusSrcAlpha 
       
         Pass {
            
            GLSLPROGRAM
            #include "UnityCG.glslinc"
            #pragma multi_compile_builtin


            #ifdef VERTEX
        
varying vec3 N,P,lightDir;
varying vec2 TextureCoordinate;


void main()
{  
    //Transform vertex by modelview and projection matrices
    gl_Position =gl_ModelViewProjectionMatrix * gl_Vertex;//world space ? or object space
    gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;//
     TextureCoordinate = gl_TexCoord[0].xy;
     
    N = normalize(gl_NormalMatrix * gl_Normal);
    vec3 lPosition = vec3(gl_ProjectionMatrix * vec4(-500.0, 50.0,-400.0,1));
    vec3 ecPosition = vec3(gl_ModelViewMatrix * gl_Vertex);
    lightDir = normalize( lPosition -ecPosition);
     P=    gl_Position.xyz; 
    gl_FrontColor = gl_Color;
        
}




            
            #endif
            
            #ifdef FRAGMENT
uniform vec4 _Color;
uniform vec4 _ColorB;
uniform sampler2D _MainTex;
varying vec3 N,P,lightDir;
varying vec2 TextureCoordinate;




uniform float _LumMin;    
uniform float _LumMax;    
uniform float _tolerence;
uniform float _feather;


#define premultiply(v) vec4(v.a*v.rgb,v.a)
#define unpremultiply(c) (c.a >0.) && (c.a <1.) ? vec4(c.rgb/c.a,c.a) : c


  //-------------//


        vec4 myColorHueKeyer(vec3 color,vec3 colorB,vec2 lumrange,float tolerence,float feather){
        vec4 pixel;
        vec3 Npixel,Ncolor;
        float ld,mask,Lpixel;
        
        pixel= unpremultiply(texture2D(_MainTex,TextureCoordinate));
        
        Npixel=normalize(pixel.rgb);
        Ncolor=normalize(color);
        mask= length(Npixel-Ncolor);
        Ncolor=normalize(colorB);
        
        mask=min(length(Npixel-Ncolor),mask);
        mask=(mask-tolerence)*(1.0/abs(feather));    //4.0-(mix(1.0,0.25,feather)-d)*mix(1.0,16.0,feather);
        
        Lpixel=(pixel.r+pixel.g+pixel.b)*(1.0/3.0);
        ld= (Lpixel>=lumrange.x) ? (Lpixel<=lumrange.y) ? 0.0 :  Lpixel-lumrange.y :  lumrange.x-Lpixel;
        ld= ld*(5.0/abs(feather));
         
        mask=max(ld,mask);
        mask=(feather<0.0) ? 1.0-clamp(mask,0.0,1.0) : clamp(mask,0.0,1.0);
        
        pixel.a=pixel.a*mask;
        return premultiply(pixel);
        }


    
    vec4 shade(vec4 tcolor)
    {     //Add shader uses specular but texture is self illum     
        //tcolor=_Color * tcolor;
        tcolor.a=sin(P.x*2.);
        return tcolor;
    } 


            void main()
            {    
                gl_FragColor = myColorHueKeyer(_Color.rgb,_ColorB.rgb, vec2(_LumMin,_LumMax),_tolerence,_feather);
            }
            
            #endif
            
            ENDGLSL
        }
    }
}