# original example on https://cairographics.org/samples/

import ../cairo/cairo
import math

var
  serface = imageSurfaceCreate(FORMAT.ARGB32, 256, 256)
  ctx = serface.create()

var
  x=25.6
  y=128.0
  x1=102.4
  y1=230.4
  x2=153.6
  y2=25.6
  x3=230.4
  y3=128.0

ctx.move_to(x, y)
ctx.curve_to(x1, y1, x2, y2, x3, y3)

ctx.set_line_width( 10.0)
ctx.stroke()

ctx.set_source_rgba(1, 0.2, 0.2, 0.6)
ctx.set_line_width(6.0)
ctx.move_to(x, y)
ctx.line_to(x1, y1)
ctx.move_to(x2, y2)
ctx.line_to(x3, y3)
ctx.stroke()

discard serface.writeToPng("curve_to.png")