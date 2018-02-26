# original example on https://cairographics.org/samples/

import ../cairo/cairo
import math

var
  serface = imageSurfaceCreate(FORMAT.ARGB32, 256, 256)
  ctx = serface.create()

var
  image = imageSurfaceCreateFromPng("data/romedalen.png")
  w = float image.imageSurfaceGetWidth()
  h = float image.imageSurfaceGetHeight()

var pattern = patternCreateForSurface(image)
pattern.set_extend(Extend.REPEAT)

ctx.translate(128.0, 128.0)
ctx.rotate(PI / 4)
ctx.scale(1.0 / sqrt(2.0), 1.0 / sqrt(2.0))
ctx.translate(-128.0, -128.0)

var matrix: Matrix
initScale(addr matrix, w/256.0 * 5.0, h/256.0 * 5.0)
pattern.setMatrix(addr matrix)

ctx.setSource(pattern)

ctx.rectangle(0, 0, 256.0, 256.0)
ctx.fill()

pattern.destroy()
image.destroy()
discard serface.writeToPng("image_pattern.png")