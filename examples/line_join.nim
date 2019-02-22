# original example on https://cairographics.org/samples/

import cairo
import math

var
  surface = imageSurfaceCreate(FORMAT.argb32, 256, 256)
  ctx = surface.newContext()

ctx.setLineWidth(40.96)
ctx.moveTo(76.8, 84.48)
ctx.relLineTo(51.2, -51.2)
ctx.relLineTo(51.2, 51.2)
ctx.setLineJoin(LineJoin.miter) # default
ctx.stroke()

ctx.moveTo(76.8, 161.28)
ctx.relLineTo(51.2, -51.2)
ctx.relLineTo(51.2, 51.2)
ctx.setLineJoin(LineJoin.bevel)
ctx.stroke()

ctx.moveTo(76.8, 238.08)
ctx.relLineTo(51.2, -51.2)
ctx.relLineTo(51.2, 51.2)
ctx.setLineJoin(LineJoin.round)
ctx.stroke()

discard surface.writeToPng("examples/line_join.png")