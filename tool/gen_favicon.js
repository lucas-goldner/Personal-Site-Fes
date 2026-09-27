/*
 * Cuts web/img/favicon.ico out of the hero photo.
 *
 *   node tool/gen_favicon.js
 *
 * The whole frame is a grey smudge at 16px, so this takes the square the face
 * fills and steps it down by halves: one straight resize to 16px loses the
 * features. The sizes are the ones a browser actually asks for — 16 and 32 for
 * the tab, 48 and 64 for hidpi and the bookmark bar, 128 for a pinned
 * shortcut. A 256 entry costs 154KB that a browser downloads whether it wants
 * that size or not.
 *
 * Each image is stored as PNG, which .ico has allowed since Vista and every
 * browser in use understands.
 *
 * Renaming this file is not enough to make a browser notice: bump the version
 * on the icon link in lib/main.server.dart as well.
 *
 * Needs playwright: npx playwright@1.56 install chromium, or run it from a
 * checkout that already has it. Set CHROMIUM_PATH to use a browser that is
 * already on the machine instead of the one playwright would go looking for.
 */
const { chromium } = require("playwright");
const fs = require("fs");
const path = require("path");

const OUT = path.join(__dirname, "..", "web", "img", "favicon.ico");

/*
 * The photo as a data URL.
 *
 * Not a file:// src: the page these run in has no origin of its own, and a
 * browser will not let such a page read off the disk. The type is sniffed
 * rather than taken from the extension, which has been wrong here before.
 */
function photoDataUrl() {
  const bytes = fs.readFileSync(path.join(__dirname, "..", "web", "person2x.webp"));
  const type = bytes[0] === 0xff && bytes[1] === 0xd8 ? "image/jpeg"
    : bytes.subarray(8, 12).toString("latin1") === "WEBP" ? "image/webp"
    : "image/png";
  return `data:${type};base64,${bytes.toString("base64")}`;
}

// Head and shoulders, hair to just below the chin, as a share of the photo
// rather than pixels: the file this reads has been resized once already and
// fixed coordinates would quietly crop the wrong square.
const CROP = { x: 0.11658, y: 0.23996, side: 0.58679 };
const SIZES = [16, 32, 48, 64, 128];

(async () => {
  const browser = await chromium.launch(
    process.env.CHROMIUM_PATH ? { executablePath: process.env.CHROMIUM_PATH } : {},
  );
  const page = await browser.newPage();
  await page.setContent("<!doctype html><meta charset=utf-8>", { waitUntil: "load" });

  const pngs = await page.evaluate(async ({ crop, sizes, photo }) => {
    const img = new Image();
    img.src = photo;
    await img.decode();
    const draw = (w, h, source, sx, sy, sw, sh) => {
      const c = document.createElement("canvas");
      c.width = w; c.height = h;
      const ctx = c.getContext("2d");
      ctx.imageSmoothingEnabled = true;
      ctx.imageSmoothingQuality = "high";
      ctx.drawImage(source, sx, sy, sw, sh, 0, 0, w, h);
      return c;
    };
    const side = img.naturalWidth * crop.side;
    const base = draw(512, 512, img, img.naturalWidth * crop.x, img.naturalHeight * crop.y, side, side);
    const out = {};
    for (const size of sizes) {
      let c = base;
      while (c.width / 2 >= size) c = draw(c.width / 2, c.height / 2, c, 0, 0, c.width, c.height);
      if (c.width !== size) c = draw(size, size, c, 0, 0, c.width, c.height);
      out[size] = c.toDataURL("image/png").split(",")[1];
    }
    return out;
  }, { crop: CROP, sizes: SIZES, photo: photoDataUrl() });

  await browser.close();

  // A 6-byte header, a 16-byte entry per image, then the PNG payloads.
  const images = SIZES.map((size) => ({ size, data: Buffer.from(pngs[size], "base64") }));
  const header = Buffer.alloc(6);
  header.writeUInt16LE(0, 0);
  header.writeUInt16LE(1, 2); // 1 = icon
  header.writeUInt16LE(images.length, 4);

  const entries = [];
  let offset = 6 + images.length * 16;
  for (const { size, data } of images) {
    const e = Buffer.alloc(16);
    e.writeUInt8(size === 256 ? 0 : size, 0); // 0 means 256
    e.writeUInt8(size === 256 ? 0 : size, 1);
    e.writeUInt8(0, 2);  // palette colours
    e.writeUInt8(0, 3);  // reserved
    e.writeUInt16LE(1, 4);   // colour planes
    e.writeUInt16LE(32, 6);  // bits per pixel
    e.writeUInt32LE(data.length, 8);
    e.writeUInt32LE(offset, 12);
    entries.push(e);
    offset += data.length;
  }

  fs.writeFileSync(OUT, Buffer.concat([header, ...entries, ...images.map((i) => i.data)]));
  console.log("wrote " + OUT + " (" + images.map((i) => i.size).join(", ") + ")");
})();
