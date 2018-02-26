# original example on https://cairographics.org/samples/

import ../cairo/cairo
import math

var
  serface = imageSurfaceCreate(FORMAT.ARGB32, 256, 256)
  ctx = serface.create()

# a custom shape that could be wrapped in a function
var
  x         = 25.6        # parameters like ctx.rectangle
  y         = 25.6
  width         = 204.8
  height        = 204.8
  aspect        = 1.0     # aspect ratio
  corner_radius = height / 10.0   # and corner curvature radius
  radius = corner_radius / aspect
  degrees = PI / 180.0

ctx.new_sub_path()
ctx.arc(x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
ctx.arc(x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
ctx.arc(x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
ctx.arc(x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
ctx.close_path()

ctx.set_source_rgb(0.5, 0.5, 1)
ctx.fill_preserve()
ctx.set_source_rgba(0.5, 0, 0, 0.5)
ctx.set_line_width(10.0)
ctx.stroke()

discard serface.writeToPng("rounded_rectangle.png")