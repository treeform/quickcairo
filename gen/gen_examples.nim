# generates examples markdown

import os
import strutils


echo """
# cairo

Nim cairo wrapper

"""


proc cutBetween(str, a, b: string): string =
  let
    cutA = str.find(a)
    cutB = str.find(b)
  if cutA == -1 or cutB == -1:
    return ""
  return str[cutA + a.len..<cutB]


for kind, path in walkDir("examples"):
  if path.endsWith("nim"):
    let code = readFile(path)
    let innerCode = code.cutBetween("ctx = serface.create()\n", "\ndiscard serface.writeToPng(")
    echo "## example: ", path
    echo "```nim"
    echo innerCode
    echo "```"
    echo "![example output](https://github.com/treeform/cairo/raw/master/", path.replace(".nim", ".png"), ")"
    echo ""


echo """
Automatically generated from latest header files of cairo 1.15

Main module is cairo.nim, which contains also PDF, SVG and other
stuff not depending on other modules.

Xlib, win32, GL is supported by cairo_xlib.nim, cairo_win32.nim
and cairo_gl.nim (still untested.)

Other backends like xcb, ft, quartz are still unsupported because
imported wrappers are still unavailable.

To generate the wrapper files: cd into gen directory, make sure path
to cairo source directory containing C header files is correct in
file prep_cairo.sh. Then execute command "bash prep_cairo.sh".
This script executes a few tiny Ruby scripts, so you should ensure
that Ruby is installed on your computer -- perl also.

Script works with latest c2nim 0.9.8!
"""
