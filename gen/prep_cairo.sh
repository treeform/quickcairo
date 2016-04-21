#!/bin/bash
# S. Salewski, 19-APR-2016
# Generate Cairo bindings for Nim
#
# TODO: I think set_dash() is wrong
# TODO: Maybe we should define different surface types, i.e. image surface, pdf surface...

cairo_dir="/home/stefan/Downloads/cairo-1.15.2/"
final="final.h" # the input file for c2nim

h=`pwd`
cd  $cairo_dir/src
cat cairo.h cairo-pdf.h cairo-ps.h cairo-svg.h cairo-xml.h cairo-script.h cairo-skia.h cairo-drm.h cairo-tee.h cairo-xlib.h cairo-win32.h cairo-gl.h > $h/final.h

cd $h

sed -i "1i#def CAIRO_BEGIN_DECLS" $final
sed -i "1i#def CAIRO_END_DECLS" $final
sed -i "1i#def cairo_public" $final

# delete a few constructs which c2nim does not really like -- guess we will not miss them
i="\
#ifdef  __cplusplus
# define CAIRO_BEGIN_DECLS  extern \"C\" {
# define CAIRO_END_DECLS    }
#else
# define CAIRO_BEGIN_DECLS
# define CAIRO_END_DECLS
#endif

#ifndef cairo_public
# if defined (_MSC_VER) && ! defined (CAIRO_WIN32_STATIC_BUILD)
#  define cairo_public __declspec(dllimport)
# else
#  define cairo_public
# endif
#endif
"
perl -0777 -p -i -e "s/\Q$i\E//s" $final
i="\
#define CAIRO_VERSION CAIRO_VERSION_ENCODE(	\\
	CAIRO_VERSION_MAJOR,			\\
	CAIRO_VERSION_MINOR,			\\
	CAIRO_VERSION_MICRO)
"
perl -0777 -p -i -e "s/\Q$i\E//s" $final
i="\
#define CAIRO_VERSION_STRINGIZE_(major, minor, micro)	\\
	#major\".\"#minor\".\"#micro
#define CAIRO_VERSION_STRINGIZE(major, minor, micro)	\\
	CAIRO_VERSION_STRINGIZE_(major, minor, micro)

#define CAIRO_VERSION_STRING CAIRO_VERSION_STRINGIZE(	\\
	CAIRO_VERSION_MAJOR,				\\
	CAIRO_VERSION_MINOR,				\\
	CAIRO_VERSION_MICRO)
"
perl -0777 -p -i -e "s/\Q$i\E//s" $final

# c2nim wants the {} for structs
sed  -i "s/typedef struct _cairo_surface/typedef struct _cairo_surface {}/g" $final
sed  -i "s/typedef struct _cairo_device/typedef struct _cairo_device {}/g" $final
sed  -i "s/typedef struct _cairo_pattern/typedef struct _cairo_pattern {}/g" $final
sed  -i "s/typedef struct _cairo_scaled_font/typedef struct _cairo_scaled_font {}/g" $final
sed  -i "s/typedef struct _cairo_font_face/typedef struct _cairo_font_face {}/g" $final
sed  -i "s/typedef struct _cairo_font_options/typedef struct _cairo_font_options {}/g" $final
sed  -i "s/typedef struct _cairo_region/typedef struct _cairo_region {}/g" $final
sed  -i "s/typedef struct _cairo cairo_t;/typedef struct _cairo {} cairo_t;/g" $final

ruby fix_.rb $final

i='
#ifdef C2NIM
#  dynlib lib
#endif
'
perl -0777 -p -i -e "s/^/$i/" $final

c2nim --nep1 --skipcomments --skipinclude $final
sed -i '/  $/d' final.nim

sed -i 's/^else[:]$//' final.nim
sed -i '2i\  CAIRO_HAS_PNG_FUNCTIONS = true' final.nim
sed -i '2i\  CAIRO_HAS_PDF_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_PS_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_SVG_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_XML_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_SCRIPT_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_SKIA_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_DRM_SURFACE = true' final.nim
sed -i '2i\  CAIRO_HAS_TEE_SURFACE = true' final.nim
sed -i '2iconst ' final.nim

i='type
  CairoBoolT* = cint
'
j='type
  CairoBoolT* = distinct cint

# we should not need these constants often, because we have converters to and from Nim bool
const
  CAIRO_FALSE* = CairoBoolT(0)
  CAIRO_TRUE* = CairoBoolT(1)

converter cbool*(nimbool: bool): CairoBoolT =
  ord(nimbool).CairoBoolT

converter toBool*(cbool: CairoBoolT): bool =
  int(cbool) != 0

'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

# replace the cairo_t with cairo_context_t -- so finally we will get a plain Context
i=`grep -i -c ContextT final.nim`
if [ $i != 0 ]; then echo 'Error: file contains symbol context_t already!'; exit; fi;

ruby cairo_fix_proc.rb final.nim

sed  -i "s/\bCairoT\b/CairoContextT/g" final.nim # caution -- execute after cairo_fix_proc.rb

ruby cairo_fix_T.rb final.nim cairo
ruby cairo_fix_enum_prefix.rb final.nim

sed -i 's/\bproc type\b/proc `type`/g' final.nim

# xor is an operatur in nim
sed  -i "s/proc xor\*(dst: Region; other: Region): Status/proc xor_op*(dst: Region; other: Region): Status/g" final.nim

# enums starting with a digit
sed  -i "s/^      1_4, 1_5/      V1_4, V1_5/g" final.nim
sed  -i "s/^      1_1, 1_2/      V1_1, V1_2/g" final.nim
sed  -i "s/unused\*: cint/unused: cint/g" final.nim
i="\
    PsLevel* {.size: sizeof(cint), pure.} = enum
      2, 3
"
j="\
    PS_Level* {.size: sizeof(cint), pure.} = enum
      L2, L3
"
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( TextClusterFlags)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cint)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cint)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cuint)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( culong)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cdouble)/\1\2\3\4var\6/sg' final.nim
perl -0777 -p -i -e 's/(proc )(`?\w+=?`?\*)?([(])([^)]* )(ptr)( cdouble)/\1\2\3\4var\6/sg' final.nim

sed -i 's/: ptr var /: var ptr /g' final.nim
sed -i 's/\(0x\)0*\([0123456789ABCDEF]\)/\1\2/g' final.nim

# we use our own defined pragma
sed  -i "s/\bdynlib: lib\b/libcairo/g" final.nim

sed  -i "s/\bCAIRO_MIME_TYPE_/MIME_TYPE_/g" final.nim
sed  -i "s/\bFLAG_BACKWARD = 0x1/BACKWARD = 0x1/g" final.nim

perl -0777 -p -i -e "s~([=:] proc \(.*?\)(?:: \w+)?)~\1 {.cdecl.}~sg" final.nim
sed -i 's/\([,=(<>] \{0,1\}\)[(]\(`\{0,1\}\w\+`\{0,1\}\)[)]/\1\2/g' final.nim

i='proc paintWithAlpha*(cr: Context; alpha: cdouble) {.
    importc: "cairo_paint_with_alpha", libcairo.}
'
j='proc paint*(cr: Context; alpha: cdouble) {.
    importc: "cairo_paint_with_alpha", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$i$j/s" final.nim

# some procs with get_ prefix do not return something but need var objects instead of pointers:
# vim search term for candidates: proc get_.*\n\?.*\n\?.*) {
i='proc getFontMatrix*(cr: Context; matrix: Matrix) {.
    importc: "cairo_get_font_matrix", libcairo.}
'
j='proc getFontMatrix*(cr: Context; matrix: var MatrixObj) {.
    importc: "cairo_get_font_matrix", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc setFontOptions*(cr: Context; options: FontOptions) {.
    importc: "cairo_set_font_options", libcairo.}
'
j='proc setFontOptions*(cr: Context; options: FontOptions) {.
    importc: "cairo_set_font_options", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc getFontOptions*(cr: Context; options: FontOptions) {.
    importc: "cairo_get_font_options", libcairo.}
'
j='proc getFontOptions*(cr: Context; options: var FontOptionsObj) {.
    importc: "cairo_get_font_options", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc setFontFace*(cr: Context; fontFace: FontFace) {.
    importc: "cairo_set_font_face", libcairo.}
'
j='proc setFontFace*(cr: Context; fontFace: FontFace) {.
    importc: "cairo_set_font_face", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc getFontFace*(cr: Context): FontFace {.
    importc: "cairo_get_font_face", libcairo.}
'
j='proc getFontFace*(cr: Context): var FontFaceObj {.
    importc: "cairo_get_font_face", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc setScaledFont*(cr: Context; scaledFont: ScaledFont) {.
    importc: "cairo_set_scaled_font", libcairo.}
'
j='proc setScaledFont*(cr: Context; scaledFont: ScaledFont) {.
    importc: "cairo_set_scaled_font", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc getFontMatrix*(scaledFont: ScaledFont;
                                  fontMatrix: Matrix) {.
    importc: "cairo_scaled_font_get_font_matrix", libcairo.}
'
j='proc getFontMatrix*(scaledFont: ScaledFont;
                                  fontMatrix: var MatrixObj) {.
    importc: "cairo_scaled_font_get_font_matrix", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc getCtm*(scaledFont: Scaledfont; ctm: Matrix) {.
    importc: "cairo_scaled_font_get_ctm", libcairo.}
'
j='proc getCtm*(scaledFont: Scaledfont; ctm: var MatrixObj) {.
    importc: "cairo_scaled_font_get_ctm", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc getScaleMatrix*(scaledFont: ScaledFont;
                                   scaleMatrix: Matrix) {.
    importc: "cairo_scaled_font_get_scale_matrix", libcairo.}
'
j='proc getScaleMatrix*(scaledFont: ScaledFont;
                                   scaleMatrix: var MatrixObj) {.
    importc: "cairo_scaled_font_get_scale_matrix", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc getFontOptions*(scaledFont: ScaledFont;
                                   options: FontOptions) {.
    importc: "cairo_scaled_font_get_font_options", libcairo.}
'
j='proc getFontOptions*(scaledFont: ScaledFont;
                                   options: var FontOptionsObj) {.
    importc: "cairo_scaled_font_get_font_options", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc getMatrix*(cr: Context; matrix: Matrix) {.
    importc: "cairo_get_matrix", libcairo.}
'
j='proc getMatrix*(cr: Context; matrix: var MatrixObj) {.
    importc: "cairo_get_matrix", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc getFontOptions*(surface: Surface;
                                options: FontOptions) {.
    importc: "cairo_surface_get_font_options", libcairo.}
'
j='proc getFontOptions*(surface: Surface;
                                options: var FontOptionsObj) {.
    importc: "cairo_surface_get_font_options", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc getMatrix*(pattern: Pattern; matrix: Matrix) {.
    importc: "cairo_pattern_get_matrix", libcairo.}
'
j='proc getMatrix*(pattern: Pattern; matrix: var MatrixObj) {.
    importc: "cairo_pattern_get_matrix", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc getExtents*(region: Region;
                           extents: RectangleInt) {.
'
j='proc getExtents*(region: Region;
                           extents: var RectangleIntObj) {.
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim
i='proc getRectangle*(region: Region; nth: cint;
                             rectangle: RectangleInt) {.
    importc: "cairo_region_get_rectangle", libcairo.}
'
j='proc getRectangle*(region: Region; nth: cint;
                             rectangle: var RectangleIntObj) {.
    importc: "cairo_region_get_rectangle", libcairo.}
'
perl -0777 -p -i -e "s/\Q$i\E/$j/s" final.nim

# allow MatrixObj as IN parameter
i='type
  Pattern* =  ptr PatternObj
'
j='converter matrixobj2matrix(m: var MatrixObj): Matrix =
  addr(m)
'
perl -0777 -p -i -e "s/\Q$i\E/$j$i/s" final.nim

sed  -i "s/cairo_Has_Glesv2Surface/CAIRO_HAS_GLESV2_SURFACE/g" final.nim
sed  -i "s/cairo_Has_Win32Surface/CAIRO_HAS_WIN32_SURFACE/g" final.nim
sed  -i "s/cairo_Has_Win32Font/CAIRO_HAS_WIN32_FONT/g" final.nim

sed  -i "s/\(cairo_Has_Png_Functions\)/\U\1/g" final.nim
sed  -i "s/\(cairo_Has_Pdf_Surface\)/\U\1/g" final.nim
sed  -i "s/\(cairo_Has_Ps_Surface\)/\U\1/g" final.nim
sed  -i "s/\(cairo_Has_Svg_Surface\)/\U\1/g" final.nim
sed  -i "s/\(cairo_Has_Xml_Surface\)/\U\1/g" final.nim
sed  -i "s/\(cairo_Has_Script_Surface\)/\U\1/g" final.nim
sed  -i "s/\(cairo_Has_Skia_Surface\)/\U\1/g" final.nim
sed  -i "s/\(cairo_Has_Drm_Surface\)/\U\1/g" final.nim
sed  -i "s/\(cairo_Has_Tee_Surface\)/\U\1/g" final.nim
sed  -i "s/\(cairo_Has_Xlib_Surface\)/\U\1/g" final.nim
sed  -i "s/\(cairo_Has_Gl_Surface\)/\U\1/g" final.nim
sed  -i "s/\(cairo_Has_Glx_Functions\)/\U\1/g" final.nim
sed  -i "s/\(cairo_Has_Wgl_Functions\)/\U\1/g" final.nim
sed  -i "s/\(cairo_Has_Egl_Functions\)/\U\1/g" final.nim

# generate procs without get_ and set_ prefix
perl -0777 -p -i -e "s/(\n\s*)(proc set)([A-Z]\w+)(\*\([^}]*\) {[^}]*})/\$&\1proc \`\l\3=\`\4/sg" final.nim
perl -0777 -p -i -e "s/(\n\s*)(proc get)([A-Z]\w+)(\*\([^}]*\): \w[^}]*})/\$&\1proc \l\3\4/sg" final.nim

# now separare the xlib, win32 and open gl submodules
csplit final.nim '/when CAIRO_HAS_GL_SURFACE or CAIRO_HAS_GLESV2_SURFACE:/'
mv xx00 final.nim
mv xx01 cairo_gl.nim
sed -i "1d" cairo_gl.nim
sed -i 's/^  //' cairo_gl.nim
sed -i '1iinclude "cairo_pragma.nim"' cairo_gl.nim
sed -i "1iimport cairo" cairo_gl.nim
sed -i "2i# from opengl import" cairo_gl.nim
sed -i '4iconst' cairo_gl.nim
sed -i '5i\  CAIRO_HAS_GLX_FUNCTIONS = false' cairo_gl.nim
sed -i '6i\  CAIRO_HAS_WGL_FUNCTIONS = false' cairo_gl.nim
sed -i '7i\  CAIRO_HAS_EGL_FUNCTIONS = false' cairo_gl.nim
sed  -i "s/\(proc glSurface\)\([A-Z]\)\(\.*\)/proc \l\2\3/g" cairo_gl.nim
sed -i 's/proc create/proc surfaceCreate/g' cairo_gl.nim
sed  -i "s/\(proc glDevice\)\([A-Z]\)\(\.*\)/proc \l\2\3/g" cairo_gl.nim
sed  -i "s/\(proc glxDevice\)\([A-Z]\)\(\.*\)/proc \l\2\3/g" cairo_gl.nim
sed -i 's/proc create/proc deviceCreate/g' cairo_gl.nim
sed  -i "s/\(proc wglDevice\)\([A-Z]\)\(\.*\)/proc \l\2\3/g" cairo_gl.nim
sed  -i "s/\(proc eglDevice\)\([A-Z]\)\(\.*\)/proc \l\2\3/g" cairo_gl.nim
sed -i 's/proc create/proc deviceCreate/g' cairo_gl.nim

csplit final.nim '/when CAIRO_HAS_WIN32_SURFACE:/'
mv xx00 final.nim
mv xx01 cairo_win32.nim
sed -i "1d" cairo_win32.nim
sed -i 's/^  //' cairo_win32.nim
sed -i '1iinclude "cairo_pragma.nim"' cairo_win32.nim
sed -i "1iimport cairo" cairo_win32.nim
sed -i "2ifrom windows import HDC, LOGFONTW, HFONT" cairo_win32.nim
sed -i '3iconst CAIRO_HAS_WIN32_FONT = true' cairo_win32.nim
sed  -i "s/\(proc win32ScaledFont\)\([A-Z]\)\(\.*\)/proc \l\2\3/g" cairo_win32.nim
sed  -i "s/\(proc win32Surface\)\([A-Z]\)\(\.*\)/proc \l\2\3/g" cairo_win32.nim
sed -i 's/proc create/proc surfaceCreate/g' cairo_win32.nim
sed  -i "s/\(proc win32\)\([A-Z]\)\(\.*\)/proc \l\2\3/g" cairo_win32.nim

csplit final.nim '/when CAIRO_HAS_XLIB_SURFACE:/'
mv xx00 final.nim
mv xx01 cairo_xlib.nim
sed -i "1d" cairo_xlib.nim
sed -i 's/^  //' cairo_xlib.nim
sed -i '1iinclude "cairo_pragma.nim"' cairo_xlib.nim
sed -i "1iimport cairo" cairo_xlib.nim
sed -i "2ifrom x import TDrawable, TPixmap" cairo_xlib.nim
sed -i "3ifrom xlib import PDisplay, PScreen, PVisual" cairo_xlib.nim
sed  -i "s/\(proc xlibSurface\)\([A-Z]\)\(\.*\)/proc \l\2\3/g" cairo_xlib.nim
sed  -i "s/\(proc xlibDevice\)\([A-Z]\)\(\.*\)/proc \l\2\3/g" cairo_xlib.nim
sed -i 's/proc create/proc surfaceCreate/g' cairo_xlib.nim

# legacy xlib symbols
sed -i 's/\bptr Display\b/PDisplay/' cairo_xlib.nim
sed -i 's/\bDrawable\b/TDrawable/' cairo_xlib.nim
sed -i 's/\bptr Visual\b/PVisual/' cairo_xlib.nim
sed -i 's/\bPixmap\b/TPixmap/' cairo_xlib.nim
sed -i 's/\bptr Screen\b/PScreen/' cairo_xlib.nim

cat -s final.nim > cairo.nim
sed -i '2iinclude "cairo_pragma.nim"' cairo.nim
sed -i '1is/\\bCairoT\\b/CairoContextT/g' cairo_sedlist
sed -i '1is/\\bCairoFontTypeT\\b/cairo.FontType/g' cairo_sedlist
sed -i '1is/\\bCairoContentT\\b/cairo.Content/g' cairo_sedlist
sed -i '1is/\\bCairoFormatT\\b/cairo.Format/g' cairo_sedlist

rm final.h
rm final.nim

