# generates examples markdown

import os
import strutils

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
    echo "![GitHub Logo](", path.replace(".nim", ".png"), ")"
    echo ""
