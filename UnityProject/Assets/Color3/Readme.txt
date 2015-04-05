About

  Color3 (c) Insidious Technologies. All rights reserved.

  Color3 is a Advanced Color Grading Plugin for Unity Pro
  
  Current Features:
	
    * Advanced color grading
    * Semi-automated Photoshop workflow
    * File-based standard workflow
    * Dynamic blending between profiles
    * Texture-based per-pixel masking
	 
  Redistribution of Color3 is frowned upon. If you want to share the 
  software, please refer others to the official download page:

    http://www.insidious.pt/#color3

Minimum Requirements

  Software

    Unity 3.5.7f6

Description

  Color3 effectively enables you to apply color grading to your entire game 
  by mimicking the color changes made inside a tool like Photoshop. 
  E.g. changing contrast, color curves, exposure, saturation, hue.
  
  Color3 provides an integrated editor with two possible workflows; a 
  semi-automated Photoshop workflow where Color3 actually connects to Photoshop 
  to upload the reference frame and download the modified frame. Or a standard 
  file-based workflow, compatible with all image editing software.

Workflow Overview
  
  1) Export a reference screenshot from Unity, using Color3
    
  2) Open reference screenshot in your favorite image editing software
    
  3) Apply any color changes you desire. E.g. hue, exposure
    
  4) Save image and load it into Color3
    
  5) Color3 automatically generates a texture containing a color grading 
     look-up-table (LUT).
       
  6) Apply a "Color3 Grading" component to your main camera.
    
  7) Assign previously generated LUT texture to the "Color3 Grading" component.
    
  8) The changes you made to the reference screenshot are now applied to every
     frame of your game.
    
  Please read the Docs/Manual.pdf, included in the package, for a detailed 
  step-by-step workflow description inside a Color3-enabled Unity installation.
    
Technical Artistic Considerations

  Color3 only works with color manipulation, not with painting or other changes.  

Troubleshooting

  Your LUT doesn't look right?

    1) Go to your LUT import settings and set "Texture Type" to Advanced.
    2) Enable  "Bypass sRGB Sampling".
    3) Disable "Generate Mip Maps".
    4) Set "Wrap Mode" to Clamp.
    5) Set "Filter Mode" to Bilinear.
    6) Set "Aniso Level" to 0.
    7) Set "Max Size" to 1024.
    8) Set "Format" to Automatic Truecolor.

  Having trouble connecting?

    1) Use Photoshop CS 5.1 or above.
    2) Add Unity and Photoshop to firewall as exceptions.
    3) Set your active Build Target to Standalone.

Feedback

  To file error reports, questions or suggestions, you may use 
  our feedback form online:
	
    http://www.insidious.pt/#feedback

  Or contact us directly:

    For general inquiries: info@insidious.pt
    For technical support: support@insidious.pt (customers only)