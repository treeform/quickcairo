# Package

version      = "1.15.2"
author       = "Stefan Salewski"
description  = "Wrapper for cairo, a vector graphics library with display and print output"
license      = "MIT"

srcDir       = "src"

# Deps

requires "nim >= 0.17.0"


task test, "Tests the examples":
  exec "nim c -r examples/arc"
  exec "nim c -r examples/clip"
  exec "nim c -r examples/clip_image"
  exec "nim c -r examples/curve_to"
  exec "nim c -r examples/dash"
  exec "nim c -r examples/fill_and_stroke"
  exec "nim c -r examples/gradient"
  exec "nim c -r examples/image"
  exec "nim c -r examples/image_pattern"
  exec "nim c -r examples/line_cap"
  exec "nim c -r examples/line_join"
  exec "nim c -r examples/rounded_rectangle"
  exec "nim c -r examples/text"
  exec "nim c -r examples/text_align"