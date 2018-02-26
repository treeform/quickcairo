# original example on https://cairographics.org/samples/

import ../cairo/cairo
import math

var
  serface = imageSurfaceCreate(FORMAT.ARGB32, 256, 256)
  ctx = serface.create()

ctx.selectFontFace("Sans", FONT_SLANT.NORMAL, FONT_WEIGHT.NORMAL)
ctx.setFontSize(90.0)

ctx.moveTo(10.0, 135.0)
ctx.showText("Hello")

ctx.moveTo(70.0, 165.0)
ctx.textPath("void")
ctx.setSourceRgb(0.5, 0.5, 1)
ctx.fillPreserve()
ctx.setSourceRgb(0, 0, 0)
ctx.setLineWidth(2.56)
ctx.stroke()

# draw helping lines
ctx.setSourceRgba(1, 0.2, 0.2, 0.6)
ctx.arc(10.0, 135.0, 5.12, 0, 2*PI)
ctx.closePath()
ctx.arc(70.0, 165.0, 5.12, 0, 2*PI)
ctx.fill()


discard serface.writeToPng("text.png")