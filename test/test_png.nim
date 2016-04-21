#http://zetcode.com/gfx/cairo/cairobackends/

import cairo

var
  s: Surface
  cr: Context # new 1.0 type

s = imageSurfaceCreate(FORMAT.ARGB32, 390, 60)
cr = create(s)

cr.setSourceRgb(0, 0, 0)
selectFontFace(cr, "Sans", FONT_SLANT.NORMAL, FONT_WEIGHT.NORMAL)
setFontSize(cr, 40)

moveTo(cr, 10, 50)
cr.showText("Disziplin ist Macht.")

discard writeToPng(s, "image.png")

destroy(cr)
destroy(s)


