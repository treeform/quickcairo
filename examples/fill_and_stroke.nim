# original example on https://cairographics.org/samples/

import ../cairo/cairo
import math

var
  serface = imageSurfaceCreate(FORMAT.ARGB32, 256, 256)
  ctx = serface.create()

ctx.move_to(128.0, 25.6)
ctx.line_to(230.4, 230.4)
ctx.rel_line_to(-102.4, 0.0)
ctx.curve_to(51.2, 230.4, 51.2, 128.0, 128.0, 128.0)
ctx.close_path()

ctx.move_to(64.0, 25.6)
ctx.rel_line_to(51.2, 51.2)
ctx.rel_line_to(-51.2, 51.2)
ctx.rel_line_to(-51.2, -51.2)
ctx.close_path()

ctx.set_line_width(10.0)
ctx.set_source_rgb(0, 0, 1)
ctx.fill_preserve()
ctx.set_source_rgb(0, 0, 0)
ctx.stroke()

discard serface.writeToPng("fill_and_stroke.png")