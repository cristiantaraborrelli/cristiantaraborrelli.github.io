from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page(viewport={"width": 1080, "height": 1080})
    page.goto("http://localhost:8080/instagram-posts/cst-visual-concept.html", wait_until="networkidle")
    page.screenshot(
        path="C:/Users/vitto/cristiantaraborrelli.github.io/instagram-posts/cst-visual-concept.png",
        clip={"x": 0, "y": 0, "width": 1080, "height": 1080}
    )
    browser.close()
    print("Saved: cst-visual-concept.png")
