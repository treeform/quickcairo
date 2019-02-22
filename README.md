# cairo

Nim cairo wrapper, solving your vector and text drawing needs.


## example: examples/arc.nim
```nim

var
  xc = 128.0
  yc = 128.0
  radius = 100.0
  angle1 = 45.0  * PI / 180.0  # angles are specified
  angle2 = 180.0 * PI / 180.0  # in radians

ctx.setLineWidth(10.0)
ctx.arc(xc, yc, radius, angle1, angle2)
ctx.stroke()

# draw helping lines
ctx.setSource(1, 0.2, 0.2, 0.6)
ctx.setLineWidth(6.0)

ctx.arc(xc, yc, 10.0, 0, 2*PI)
ctx.fill()

ctx.arc(xc, yc, radius, angle1, angle1)
ctx.lineTo(xc, yc)
ctx.arc(xc, yc, radius, angle2, angle2)
ctx.lineTo(xc, yc)
ctx.stroke()

```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/arc.png)

## example: examples/clip.nim
```nim

ctx.arc(128.0, 128.0, 76.8, 0, 2 * PI)
ctx.clip()

ctx.newPath()  # current path is not consumed by ctx.clip()
ctx.rectangle(0, 0, 256, 256)
ctx.fill()
ctx.setSource(0, 1, 0)
ctx.moveTo(0, 0)
ctx.lineTo(256, 256)
ctx.moveTo(256, 0)
ctx.lineTo(0, 256)
ctx.setLineWidth(10.0)
ctx.stroke()

```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/clip.png)

## example: examples/clip_image.nim
```nim

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

```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/clip_image.png)

## example: examples/curve_to.nim
```nim

var
  x=25.6
  y=128.0
  x1=102.4
  y1=230.4
  x2=153.6
  y2=25.6
  x3=230.4
  y3=128.0

ctx.moveTo(x, y)
ctx.curveTo(x1, y1, x2, y2, x3, y3)

ctx.setLineWidth( 10.0)
ctx.stroke()

ctx.setSource(1, 0.2, 0.2, 0.6)
ctx.setLineWidth(6.0)
ctx.moveTo(x, y)
ctx.lineTo(x1, y1)
ctx.moveTo(x2, y2)
ctx.lineTo(x3, y3)
ctx.stroke()

```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/curve_to.png)

## example: examples/dash.nim
```nim

var
  dashes = @[
    50.0,  # ink
    10.0,  # skip
    10.0,  # ink
    10.0   # skip
  ]
  offset = -50.0

ctx.setDash(dashes, offset)
ctx.setLineWidth(10.0)

ctx.moveTo(128.0, 25.6)
ctx.lineTo(230.4, 230.4)
ctx.relLineTo(-102.4, 0.0)
ctx.curveTo(51.2, 230.4, 51.2, 128.0, 128.0, 128.0)

ctx.stroke()

```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/dash.png)

## example: examples/fill_and_stroke.nim
```nim

ctx.moveTo(128.0, 25.6)
ctx.lineTo(230.4, 230.4)
ctx.rel_lineTo(-102.4, 0.0)
ctx.curveTo(51.2, 230.4, 51.2, 128.0, 128.0, 128.0)
ctx.close_path()

ctx.moveTo(64.0, 25.6)
ctx.relLineTo(51.2, 51.2)
ctx.relLineTo(-51.2, 51.2)
ctx.relLineTo(-51.2, -51.2)
ctx.closePath()

ctx.setLineWidth(10.0)
ctx.setSource(0, 0, 1)
ctx.fillPreserve()
ctx.setSource(0, 0, 0)
ctx.stroke()

```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/fill_and_stroke.png)

## example: examples/gradient.nim
```nim

var linerGradient = patternCreateLinear(0.0, 0.0,  0.0, 256.0)
linerGradient.addColorStopRgba(1, 0, 0, 0, 1)
linerGradient.addColorStopRgba(0, 1, 1, 1, 1)
ctx.rectangle(0, 0, 256, 256)
ctx.setSource(linerGradient)
ctx.fill()

var radialGradient  = patternCreateRadial(115.2, 102.4, 25.6, 102.4,  102.4, 128.0)
radialGradient.addColorStopRgba(0, 1, 1, 1, 1)
radialGradient.addColorStopRgba(1, 0, 0, 0, 1)
ctx.setSource(radialGradient)
ctx.arc(128.0, 128.0, 76.8, 0, 2 * PI)
ctx.fill()

```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/gradient.png)

## example: examples/image.nim
```nim

var
  image = imageSurfaceCreateFromPng("examples/data/romedalen.png")
  w = float image.imageSurfaceGetWidth()
  h = float image.imageSurfaceGetHeight()

ctx.translate(128.0, 128.0)
ctx.rotate(45 * PI/180)
ctx.scale(256.0 / w, 256.0 / h)
ctx.translate(-0.5 * w, -0.5 * h)

ctx.setSourceSurface(image, 0, 0)
ctx.paint()

ctx.stroke()

```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/image.png)

## example: examples/image_pattern.nim
```nim

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

```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/image_pattern.png)

## example: examples/line_cap.nim
```nim

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

```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/line_cap.png)

## example: examples/line_join.nim
```nim

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

```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/line_join.png)

## example: examples/rounded_rectangle.nim
```nim

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

ctx.newSubPath()
ctx.arc(x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
ctx.arc(x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
ctx.arc(x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
ctx.arc(x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
ctx.closePath()

ctx.setSource(0.5, 0.5, 1)
ctx.fillPreserve()
ctx.setSource(0.5, 0, 0, 0.5)
ctx.setLineWidth(10.0)
ctx.stroke()

```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/rounded_rectangle.png)

## example: examples/text.nim
```nim

ctx.selectFontFace("Sans", FONT_SLANT.normal, FONT_WEIGHT.normal)
ctx.setFontSize(90.0)

ctx.moveTo(10.0, 135.0)
ctx.showText("Hello")

ctx.moveTo(70.0, 165.0)
ctx.textPath("void")
ctx.setSource(0.5, 0.5, 1)
ctx.fillPreserve()
ctx.setSource(0, 0, 0)
ctx.setLineWidth(2.56)
ctx.stroke()

# draw helping lines
ctx.setSource(1, 0.2, 0.2, 0.6)
ctx.arc(10.0, 135.0, 5.12, 0, 2*PI)
ctx.closePath()
ctx.arc(70.0, 165.0, 5.12, 0, 2*PI)
ctx.fill()


```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/text.png)

## example: examples/text_align.nim
```nim

ctx.selectFontFace("Sans", FONT_SLANT.normal, FONT_WEIGHT.normal)
ctx.setFontSize(52.0)

var
  text = "cairo"
  extents: TextExtents
ctx.textExtents(text, extents)

var
  x = 128.0 - (extents.width / 2 + extents.xBearing)
  y = 128.0 - (extents.height / 2 + extents.yBearing)

ctx.moveTo(x, y)
ctx.showText(text)

# draw helping lines
ctx.setSource(1, 0.2, 0.2, 0.6)
ctx.setLineWidth(6.0)
ctx.arc(x, y, 10.0, 0, 2*PI)
ctx.fill()
ctx.move_to(128.0, 0)
ctx.relLineTo(0, 256)
ctx.moveTo(0, 128.0)
ctx.relLineTo(256, 0)
ctx.stroke()

```
![example output](https://github.com/treeform/quickcairo/raw/master/examples/text_align.png)


# Realtime

![realtime example](https://github.com/treeform/quickcairo/raw/master/examples/realtime.png)

You can also use cairo for real time graphics using. Here are examples on how to use cairo with:
  * [SDL2](https://github.com/treeform/quickcairo/blob/master/examples/realtime_sdl2.nim)
  * [GLUT](https://github.com/treeform/quickcairo/blob/master/examples/realtime_glut.nim)
  * [GLFW](https://github.com/treeform/quickcairo/blob/master/examples/realtime_glfw.nim)


# About

Based on the work form: https://github.com/StefanSalewski/gintro/blob/master/gintro/cairo.nim
Forked form: https://github.com/ngtk3/nim-cairo


