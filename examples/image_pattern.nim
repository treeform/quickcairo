# original example on https://cairographics.org/samples/

import cairo
import math

var
  serface = imageSurfaceCreate(FORMAT.argb32, 256, 256)
  ctx = serface.newContext()

var
  image = imageSurfaceCreateFromPng("examples/data/romedalen.png")
  w = float image.imageSurfaceGetWidth()
  h = float image.imageSurfaceGetHeight()

var pattern = patternCreateForSurface(image)
pattern.set_extend(Extend.repeat)

ctx.translate(128.0, 128.0)
ctx.rotate(PI / 4)
ctx.scale(1.0 / sqrt(2.0), 1.0 / sqrt(2.0))
ctx.translate(-128.0, -128.0)

var matrix: Matrix
initScale(matrix, w/256.0 * 5.0, h/256.0 * 5.0)
pattern.setMatrix(matrix)

ctx.setSource(pattern)

ctx.rectangle(0, 0, 256.0, 256.0)
ctx.fill()

discard serface.writeToPng("examples/image_pattern.png")