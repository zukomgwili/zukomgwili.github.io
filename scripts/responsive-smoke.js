const playwright = require('playwright');

const siteDirArg = process.argv[2] || '_site';
const host = process.env.SMOKE_HOST || 'http://127.0.0.1:4000';

const PAGES = ['/', '/about/', '/resume.html'];
const VIEWPORTS = [
  {name: 'mobile', width: 375, height: 800},
  {name: 'tablet', width: 768, height: 1024},
  {name: 'desktop', width: 1366, height: 768},
];

(async () => {
  const browser = await playwright.chromium.launch({args: ['--no-sandbox']});
  const context = await browser.newContext();
  let anyError = false;

  for (const vp of VIEWPORTS) {
    for (const pagePath of PAGES) {
      const page = await context.newPage();
      await page.setViewportSize({width: vp.width, height: vp.height});
      const target = new URL(pagePath, host).href;
      console.log(`[CHECK] ${vp.name} ${target}`);
      try {
        const resp = await page.goto(target, { waitUntil: 'networkidle' });
        if (!resp || resp.status() >= 400) {
          console.error(`ERROR: ${target} returned ${resp ? resp.status() : 'no response'}`);
          anyError = true;
          await page.close();
          continue;
        }

        // Check for horizontal overflow (content wider than viewport)
        const scrollWidth = await page.evaluate(() => document.documentElement.scrollWidth);
        const innerWidth = await page.evaluate(() => window.innerWidth);
        if (scrollWidth > innerWidth) {
          console.error(`FAIL: ${pagePath} at ${vp.name} -- document scrollWidth=${scrollWidth} > innerWidth=${innerWidth}`);
          anyError = true;
        } else {
          console.log(`OK: ${pagePath} at ${vp.name} fits viewport (scrollWidth=${scrollWidth}, innerWidth=${innerWidth})`);
        }

        // Optionally verify that the main landmark exists
        const hasMain = await page.$('#main-content') !== null;
        if (!hasMain) {
          console.warn(`WARN: ${pagePath} at ${vp.name} is missing '#main-content' target`);
        }
      } catch (err) {
        console.error(`ERROR: ${vp.name} ${pagePath} threw:`, err);
        anyError = true;
      }
    }
  }

  await browser.close();
  if (anyError) process.exit(1);
  console.log('Responsive smoke checks PASSED');
  process.exit(0);
})();
