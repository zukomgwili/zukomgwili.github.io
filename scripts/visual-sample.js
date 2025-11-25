const playwright = require('playwright');
const fs = require('fs');
const outDir = process.argv[2] || 'visual-snapshots';
const base = process.env.SITE_URL || 'http://127.0.0.1:4000';

const PAGES = [ '/', '/about.html', '/resume.html', '/2021-08-14-bananas.html' ];
const VIEWPORTS = [
  { name: 'mobile', width: 375, height: 812 },
  { name: 'tablet', width: 768, height: 1024 },
  { name: 'desktop', width: 1366, height: 768 }
];

(async () => {
  if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });
  const browser = await playwright.chromium.launch({ args: ['--no-sandbox'] });
  const context = await browser.newContext();

  for (const vp of VIEWPORTS) {
    for (const pagePath of PAGES) {
      const page = await context.newPage();
      await page.setViewportSize({ width: vp.width, height: vp.height });
      const url = new URL(pagePath, base).href;
      console.log(`Screenshot ${vp.name} ${url}`);
      try {
        const res = await page.goto(url, { waitUntil: 'networkidle' , timeout: 15000});
        if (!res || res.status() >= 400) {
          console.warn(`Warning: ${url} returned ${res ? res.status() : 'no response'}`);
        }
        const safeName = pagePath.replace(/\W+/g, '_').replace(/^_+|_+$/g, '') || 'home';
        const filename = `${outDir}/${safeName}-${vp.name}.png`;
        await page.screenshot({ path: filename, fullPage: true });
        console.log(`Saved ${filename}`);
      } catch (err) {
        console.error('Error capturing', url, err.message);
      } finally {
        await page.close();
      }
    }
  }

  await browser.close();
  console.log('Visual sampling completed');
})();
