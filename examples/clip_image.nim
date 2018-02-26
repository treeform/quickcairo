# original example on https://cairographics.org/samples/

import ../cairo/cairo
import math

var
  serface = imageSurfaceCreate(FORMAT.ARGB32, 256, 256)
  ctx = serface.create()

ctx.arc(128.0, 128.0, 76.8, 0, 2*PI)
ctx.clip()
ctx.new_path() # path not consumed by clip()

var
  image = imageSurfaceCreateFromPng("data/romedalen.png")
  w = float image.imageSurfaceGetWidth()
  h = float image.imageSurfaceGetHeight()

ctx.scale(256.0 / w, 256.0 / h)

ctx.set_source_surface(image, 0, 0)
ctx.paint()

image.destroy()
ctx.stroke()

discard serface.writeToPng("clip_image.png")