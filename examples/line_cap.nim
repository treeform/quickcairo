# original example on https://cairographics.org/samples/

import cairo
import math

var
  serface = imageSurfaceCreate(FORMAT.argb32, 256, 256)
  ctx = serface.newContext()

ctx.setLineWidth(30.0)
ctx.setLineCap(LineCap.butt) # default
ctx.moveTo(64.0, 50.0)
ctx.lineTo(64.0, 200.0)
ctx.stroke()
ctx.setLineCap(LineCap.round)
ctx.moveTo(128.0, 50.0)
ctx.lineTo(128.0, 200.0)
ctx.stroke()
ctx.setLine_cap (LineCap.square)
ctx.moveTo(192.0, 50.0)
ctx.lineTo(192.0, 200.0)
ctx.stroke()

# draw helping lines
ctx.setSource(1, 0.2, 0.2)
ctx.setLineWidth(2.56)
ctx.moveTo(64.0, 50.0)
ctx.lineTo(64.0, 200.0)
ctx.moveTo(128.0, 50.0)
ctx.lineTo(128.0, 200.0)
ctx.moveTo(192.0, 50.0)
ctx.lineTo(192.0, 200.0)
ctx.stroke()

discard serface.writeToPng("examples/line_cap.png")