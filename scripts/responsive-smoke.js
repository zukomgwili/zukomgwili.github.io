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
      // Build candidate URLs (try /path/, /path/index.html, /path.html)
      const candidates = [];
      const base = pagePath;
      candidates.push(new URL(base, host).href);
      if (base.endsWith('/')) {
        candidates.push(new URL(base + 'index.html', host).href);
        candidates.push(new URL(base.slice(0, -1) + '.html', host).href);
      } else if (base.endsWith('.html')) {
        const alt = base.replace(/\.html$/, '/');
        candidates.push(new URL(alt, host).href);
      } else {
        candidates.push(new URL(base + '.html', host).href);
        candidates.push(new URL(base + '/', host).href);
      }

      let target = candidates[0];
      // try candidates until one succeeds
      let resp = null;
      let chosen = null;
      for (const c of candidates) {
        try {
          resp = await page.goto(c, { waitUntil: 'networkidle', timeout: 5000 });
          if (resp && resp.status() < 400) { chosen = c; break; }
        } catch (err) {
          // ignore, try next candidate
        }
      }
      if (chosen) target = chosen;
      console.log(`[CHECK] ${vp.name} ${target}`);
      console.log(`[CHECK] ${vp.name} ${target}`);
      try {
        // resp will already be set from candidate loop, if chosen
        if (!resp) {
          resp = await page.goto(target, { waitUntil: 'networkidle' });
        }
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
