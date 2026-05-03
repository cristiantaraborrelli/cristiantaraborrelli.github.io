const puppeteer = require('puppeteer');
const path = require('path');

(async () => {
  const browser = await puppeteer.launch({ headless: 'new' });
  const page = await browser.newPage();
  await page.setViewport({ width: 1080, height: 1080, deviceScaleFactor: 1 });
  await page.goto('http://localhost:8080/instagram-posts/cst-visual-concept.html', { waitUntil: 'networkidle0' });
  await page.screenshot({
    path: path.join(__dirname, 'cst-visual-concept.png'),
    clip: { x: 0, y: 0, width: 1080, height: 1080 }
  });
  await browser.close();
  console.log('Done: instagram-posts/cst-visual-concept.png');
})();
