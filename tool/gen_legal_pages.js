/*
 * Converts the JSX of the old tos/privacy pages into Dart components.
 *
 * Both pages are one <div id="scrollAllow"> holding plain text separated by
 * <br /> elements, so the conversion is: drop the JSX wrapper, turn each <br />
 * into a line break and collapse the {" "} spacing expressions JSX inserted at
 * line ends.
 */
const fs = require("fs");

function extractBody(source) {
  const start = source.indexOf('<div id="scrollAllow">');
  if (start === -1) throw new Error("wrapper not found");
  const end = source.lastIndexOf("</div>");
  return source.slice(start + '<div id="scrollAllow">'.length, end);
}

function toLines(body) {
  // {" "} is JSX's explicit space at a line break; {"text"} is escaped text.
  let text = body
    .replace(/\{"\s*"\}/g, " ")
    .replace(/\{"([^"]*)"\}/g, "$1")
    .replace(/&quot;/g, '"')
    .replace(/&amp;/g, "&");

  // Each <br /> is a line break; everything between them is one line.
  const parts = text.split(/<br\s*\/>/);
  return parts.map((part) =>
    part
      .split("\n")
      .map((line) => line.trim())
      .filter((line) => line.length > 0)
      .join(" ")
      .replace(/\s+/g, " ")
      .trim()
  );
}

function dartString(value) {
  return "'" + value.replace(/\\/g, "\\\\").replace(/'/g, "\\'").replace(/\$/g, "\\$") + "'";
}

function render(lines, className, routeDoc) {
  const out = [];
  out.push("// GENERATED FILE - do not edit by hand. See tool/gen_legal_pages.js.");
  out.push("//");
  out.push("// " + routeDoc);
  out.push("");
  out.push("import 'package:jaspr/dom.dart';");
  out.push("import 'package:jaspr/jaspr.dart';");
  out.push("");
  out.push("/// The lines of the page, in order. An empty string renders a blank line.");
  out.push("const _lines = <String>[");
  for (const line of lines) {
    out.push("  " + dartString(line) + ",");
  }
  out.push("];");
  out.push("");
  out.push("/// " + routeDoc);
  out.push("class " + className + " extends StatelessComponent {");
  out.push("  const " + className + "({super.key});");
  out.push("");
  out.push("  @override");
  out.push("  Component build(BuildContext context) {");
  out.push("    return div(id: 'scrollAllow', [");
  out.push("      for (final line in _lines) ...[");
  out.push("        if (line.isNotEmpty) .text(line),");
  out.push("        br(),");
  out.push("      ],");
  out.push("    ]);");
  out.push("  }");
  out.push("}");
  out.push("");
  return out.join("\n");
}

const jobs = [
  {
    src: "src/pages/tos.js",
    dest: "lib/pages/tos_content.dart",
    className: "TosContent",
    doc: "Impressum and privacy declaration, served at /tos.",
  },
  {
    src: "src/pages/privacy.js",
    dest: "lib/pages/privacy_content.dart",
    className: "PrivacyContent",
    doc: "App privacy policy, served at /privacy.",
  },
];

for (const job of jobs) {
  const source = fs.readFileSync(job.src, "utf8");
  const lines = toLines(extractBody(source));
  fs.writeFileSync(job.dest, render(lines, job.className, job.doc));
  console.log(job.dest + ": " + lines.length + " lines");
}
