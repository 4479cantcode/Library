import pathlib

root = pathlib.Path(__file__).resolve().parent.parent

bundle = (root / "Distribution" / "Fluent.luau").read_text(encoding="utf-8")
demo = (root / "Test.luau").read_text(encoding="utf-8")

header = """--[[
	Fluent Renewed - self contained test build.
	The library below is the local Distribution/Fluent.luau, no HTTP fetch involved.
	Regenerate with: python Lune/BuildTest.py
--]]

local Library = (function(...)
"""

out = header + bundle + "\nend)()\n\n" + demo

(root / "Distribution" / "FluentTest.lua").write_text(out, encoding="utf-8")

print("Distribution/FluentTest.lua", len(out), "bytes")
