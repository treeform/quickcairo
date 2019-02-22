  # original example on https://cairographics.org/samples/

import cairo
import math

var
  surface = imageSurfaceCreate(FORMAT.argb32, 256, 256)
  ctx = surface.newContext()

ctx.selectFontFace("Sans", FONT_SLANT.normal, FONT_WEIGHT.normal)
ctx.setFontSize(52.0)

var
  text = "cairo"
  extents: TextExtents
ctx.textExtents(text, extents)

var
  x = 128.0 - (extents.width / 2 + extents.xBearing)
  y = 128.0 - (extents.height / 2 + extents.yBearing)

ctx.moveTo(x, y)
ctx.showText(text)

# draw helping lines
ctx.setSource(1, 0.2, 0.2, 0.6)
ctx.setLineWidth(6.0)
ctx.arc(x, y, 10.0, 0, 2*PI)
ctx.fill()
ctx.move_to(128.0, 0)
ctx.relLineTo(0, 256)
ctx.moveTo(0, 128.0)
ctx.relLineTo(256, 0)
ctx.stroke()

discard surface.writeToPng("examples/text_align.png")