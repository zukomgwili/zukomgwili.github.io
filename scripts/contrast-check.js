const { chromium } = require('playwright');
const fs = require('fs');

// Use axe-core from CDN and run only color-contrast checks
const AXE_URL = 'https://cdnjs.cloudflare.com/ajax/libs/axe-core/4.9.3/axe.min.js';

async function runChecks(url) {
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();
  await page.goto(url, { waitUntil: 'networkidle' });

  // inject axe
  const axeSource = await (await fetch(AXE_URL)).text();
  await page.addScriptTag({ content: axeSource });

  // run axe with color-contrast rule only
  const result = await page.evaluate(async () => {
    return await axe.run(document, { runOnly: { type: 'rule', values: ['color-contrast'] } });
  });

  await browser.close();
  return result;
}

async function main() {
  const base = process.argv[2] || 'http://127.0.0.1:4000';
  const pages = ['/','/about/','/resume.html','/blog/'];
  let total = 0;

  for (const p of pages) {
    const url = new URL(p, base).toString();
    console.log('\nChecking', url);
    try {
      const r = await runChecks(url);
      if (r.violations && r.violations.length>0) {
        console.log('Violations found:', r.violations.length);
        r.violations.forEach(v => {
          total += v.nodes.length;
          console.log(`- ${v.id}: ${v.help} (Impact: ${v.impact})`);
          v.nodes.forEach(n => {
            console.log('  Selector:', n.target.join(', '));
          });
        });
      } else {
        console.log('PASS: no color-contrast violations on', url);
      }
    } catch (err) {
      console.error('ERROR checking', url, err.message || err);
      process.exitCode = 2;
    }
  }

  if (total > 0) {
    console.error(`\nFAIL: Total color-contrast issues: ${total}`);
    process.exit(1);
  }

  console.log('\nPASS: no color-contrast violations detected across pages.');
  process.exit(0);
}

// Node fetch shim for older Node versions in CI
async function fetch(url) {
  if (globalThis.fetch) return globalThis.fetch(url);
  const https = require('https');
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      let data = '';
      res.on('data', d => data += d);
      res.on('end', () => resolve({ text: async () => data }));
    }).on('error', reject);
  });
}

main();
