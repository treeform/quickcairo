# original example on https://cairographics.org/samples/

import ../cairo/cairo
import math

var
  serface = imageSurfaceCreate(FORMAT.ARGB32, 256, 256)
  ctx = serface.create()

ctx.arc(128.0, 128.0, 76.8, 0, 2 * PI)
ctx.clip()

ctx.new_path()  # current path is not consumed by ctx.clip()
ctx.rectangle(0, 0, 256, 256)
ctx.fill()
ctx.set_source_rgb(0, 1, 0)
ctx.move_to(0, 0)
ctx.line_to(256, 256)
ctx.move_to(256, 0)
ctx.line_to(0, 256)
ctx.set_line_width(10.0)
ctx.stroke()

discard serface.writeToPng("clip.png")