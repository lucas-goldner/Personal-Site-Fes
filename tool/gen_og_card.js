/*
 * Draws web/img/og-card.jpg, the picture a link preview shows.
 *
 * The card is laid out as a web page and photographed, rather than assembled
 * in an image library: it is the hero panel at another size, and keeping it as
 * HTML means the wording and the type are edited the way the rest of the site
 * is. Poppins is loaded from Google Fonts, so this needs a network.
 *
 *   node tool/gen_og_card.js
 *
 * 1200x630 is what every scraper wants; anything else gets cropped by one of
 * them. JPEG rather than PNG because the right half is a photograph.
 *
 * Needs playwright: npx playwright@1.56 install chromium, or run it from a
 * checkout that already has it. Set CHROMIUM_PATH to use a browser that is
 * already on the machine instead of the one playwright would go looking for.
 */
const { chromium } = require("playwright");
const path = require("path");

const OUT = path.join(__dirname, "..", "web", "img", "og-card.jpg");

const fs = require("fs");

/*
 * The photo as a data URL.
 *
 * Not a file:// src: the page these run in has no origin of its own, and a
 * browser will not let such a page read off the disk. Sniffed rather than
 * trusted to its extension, because web/person2x.png is a JPEG.
 */
function photoDataUrl() {
  const bytes = fs.readFileSync(path.join(__dirname, "..", "web", "person2x.png"));
  const type = bytes[0] === 0xff && bytes[1] === 0xd8 ? "image/jpeg" : "image/png";
  return `data:${type};base64,${bytes.toString("base64")}`;
}

const CARD = (photo) => `<!doctype html><meta charset="utf-8">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Poppins:400,500,600,800&display=swap">
<style>
  * { margin: 0; box-sizing: border-box; }
  body { width: 1200px; height: 630px; display: flex; background: #000; font-family: Poppins, sans-serif; overflow: hidden; }
  .panel { width: 660px; background: #2c343f; padding: 64px 56px; display: flex; flex-direction: column; justify-content: center; }
  .rule { width: 86px; height: 3px; background: #ffb035; margin-bottom: 26px; }
  .name { font-size: 76px; font-weight: 800; color: #fff; line-height: 1.02; letter-spacing: -1px; }
  .roles { font-size: 30px; font-weight: 600; color: #ffb035; margin-top: 18px; letter-spacing: .5px; }
  .gde { display: flex; align-items: center; gap: 12px; margin-top: 30px; font-size: 21px; font-weight: 500; color: #cfd4db; }
  .star { color: #ffb035; font-size: 24px; line-height: 1; }
  .url { margin-top: 42px; font-size: 20px; font-weight: 400; color: #8b93a0; letter-spacing: 2px; }
  .shot { flex: 1; position: relative; overflow: hidden; }
  /* Off-centre on purpose: it keeps the face out of the seam and Tokyo Tower in. */
  .shot img { position: absolute; width: 100%; height: 100%; object-fit: cover; object-position: 42% 26%; }
</style>
<body>
  <div class="panel">
    <div class="rule"></div>
    <div class="name">Lucas<br>Goldner</div>
    <div class="roles">Flutter &middot; iOS &middot; Android Engineer</div>
    <div class="gde"><span class="star">&#9733;</span><span>Flutter &amp; Dart Google Developer Expert</span></div>
    <div class="url">LUCAS-GOLDNER.COM</div>
  </div>
  <div class="shot"><img src="${photo}" alt=""></div>
</body>`;

(async () => {
  const browser = await chromium.launch(
    process.env.CHROMIUM_PATH ? { executablePath: process.env.CHROMIUM_PATH } : {},
  );
  const page = await browser.newPage({ viewport: { width: 1200, height: 630 }, deviceScaleFactor: 1 });
  await page.setContent(CARD(photoDataUrl()), { waitUntil: "load" });
  await page.evaluate(() => document.fonts.ready);
  await page.waitForTimeout(500);
  await page.screenshot({ path: OUT, type: "jpeg", quality: 88 });
  await browser.close();
  console.log("wrote " + OUT);
})();
