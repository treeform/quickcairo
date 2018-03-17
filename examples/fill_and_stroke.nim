# original example on https://cairographics.org/samples/

import cairo
import math

var
  serface = imageSurfaceCreate(FORMAT.argb32, 256, 256)
  ctx = serface.newContext()

ctx.moveTo(128.0, 25.6)
ctx.lineTo(230.4, 230.4)
ctx.rel_lineTo(-102.4, 0.0)
ctx.curveTo(51.2, 230.4, 51.2, 128.0, 128.0, 128.0)
ctx.close_path()

ctx.moveTo(64.0, 25.6)
ctx.relLineTo(51.2, 51.2)
ctx.relLineTo(-51.2, 51.2)
ctx.relLineTo(-51.2, -51.2)
ctx.closePath()

ctx.setLineWidth(10.0)
ctx.setSource(0, 0, 1)
ctx.fillPreserve()
ctx.setSource(0, 0, 0)
ctx.stroke()

discard serface.writeToPng("examples/fill_and_stroke.png")