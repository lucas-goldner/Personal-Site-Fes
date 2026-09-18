const fs = require("fs");
const rows = fs.readFileSync("/tmp/icons.json", "utf8").trim().split("\n").map(JSON.parse);
const kebab = (n) => n.replace(/^fa/, "").replace(/([a-z0-9])([A-Z])/g, "$1-$2").toLowerCase();

const header = [
  "// GENERATED FILE - do not edit by hand. See tool/gen_icons.js.",
  "//",
  "// Path data from Font Awesome Free 5.15.4, licensed CC BY 4.0",
  "// (https://fontawesome.com/license/free). The outlines are copied verbatim so",
  "// the inline SVGs render identically to the <FontAwesomeIcon> output of the",
  "// previous React site.",
  "",
  "/// A single Font Awesome glyph: its intrinsic viewBox size and outline.",
  "class FaIcon {",
  "  const FaIcon(this.prefix, this.name, this.width, this.height, this.path);",
  "",
  "  /// Font Awesome style prefix: 'fas' for solid, 'fab' for brands.",
  "  final String prefix;",
  "",
  "  /// Font Awesome icon name, e.g. 'bars'.",
  "  final String name;",
  "",
  "  /// Intrinsic viewBox width.",
  "  final int width;",
  "",
  "  /// Intrinsic viewBox height.",
  "  final int height;",
  "",
  "  /// The 'd' attribute of the glyph outline.",
  "  final String path;",
  "",
  "  /// The responsive width class Font Awesome derives from the aspect ratio.",
  "  int get faWidth => (width / height * 16).ceil();",
  "}",
  "",
].join("\n");

let out = header;
for (const r of rows) {
  const prefix = r.dir === "solid" ? "fas" : "fab";
  out += "\nconst " + r.name + " = FaIcon('" + prefix + "', '" + kebab(r.name) + "', " +
    r.w + ", " + r.h + ",\n    '" + r.path + "');\n";
}
fs.writeFileSync(process.argv[2], out);
console.log("wrote " + rows.length + " icons to " + process.argv[2]);
