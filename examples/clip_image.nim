# original example on https://cairographics.org/samples/

import cairo
import math

var
  serface = imageSurfaceCreate(FORMAT.argb32, 256, 256)
  ctx = serface.newContext()

ctx.arc(128.0, 128.0, 76.8, 0, 2*PI)
ctx.clip()
ctx.new_path() # path not consumed by clip()

var
  image = imageSurfaceCreateFromPng("examples/data/romedalen.png")
  w = float image.imageSurfaceGetWidth()
  h = float image.imageSurfaceGetHeight()

ctx.scale(256.0 / w, 256.0 / h)

ctx.setSourceSurface(image, 0, 0)
ctx.paint()

ctx.stroke()

discard serface.writeToPng("examples/clip_image.png")