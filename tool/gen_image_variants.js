// Resize/re-encode images to WebP using a headless Chromium canvas.
//
// No image library is available in this environment (no PIL, ImageMagick or
// cwebp), so the browser's own decoder and WebP encoder do the work.
//
//   node tool/gen_image_variants.js <quality> <width>[,<width>...] <file>...
//
// For each input, one output per width is written next to it as
// "<base>-<width>.webp". A width of 0 means "keep the intrinsic size", which
// re-encodes in place at the given quality.
const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

const CHROMIUM =
  process.env.CHROMIUM_PATH ||
  '/opt/pw-browsers/chromium-1194/chrome-linux/chrome';

const mime = (buf) => {
  if (buf.slice(0, 3).toString('hex') === 'ffd8ff') return 'image/jpeg';
  if (buf.slice(8, 12).toString() === 'WEBP') return 'image/webp';
  if (buf.slice(1, 4).toString() === 'PNG') return 'image/png';
  throw new Error('unrecognised image');
};

(async () => {
  const quality = Number(process.argv[2]);
  const widths = process.argv[3].split(',').map(Number);
  const files = process.argv.slice(4);
  if (!files.length) throw new Error('no input files');

  const browser = await chromium.launch({ executablePath: CHROMIUM });
  const page = await browser.newPage();

  for (const file of files) {
    const buf = fs.readFileSync(file);
    const src = `data:${mime(buf)};base64,${buf.toString('base64')}`;
    for (const width of widths) {
      const out = await page.evaluate(
        async ([src, width, quality]) => {
          const img = new Image();
          img.src = src;
          await img.decode();
          const w = width || img.naturalWidth;
          const h = Math.round((w / img.naturalWidth) * img.naturalHeight);
          const canvas = document.createElement('canvas');
          canvas.width = w;
          canvas.height = h;
          const ctx = canvas.getContext('2d');
          ctx.imageSmoothingQuality = 'high';
          ctx.drawImage(img, 0, 0, w, h);
          return {
            w,
            h,
            data: canvas.toDataURL('image/webp', quality).split(',')[1],
          };
        },
        [src, width, quality],
      );
      const dest = width
        ? path.join(
            path.dirname(file),
            `${path.basename(file, path.extname(file))}-${width}.webp`,
          )
        : file;
      const bytes = Buffer.from(out.data, 'base64');
      fs.writeFileSync(dest, bytes);
      console.log(
        `${dest}  ${out.w}x${out.h}  ${(bytes.length / 1024).toFixed(1)} KiB` +
          (width ? '' : `  (was ${(buf.length / 1024).toFixed(1)} KiB)`),
      );
    }
  }
  await browser.close();
})();
