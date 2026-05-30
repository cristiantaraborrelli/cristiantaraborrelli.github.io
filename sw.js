// Cristian Taraborrelli Studio — Service Worker
// Strategy: stale-while-revalidate for HTML, cache-first for static assets.
// Allows offline reading of previously-visited pages and instant repeat visits.

const CACHE_NAME = 'cts-v1-2026-05-30';
const STATIC_ASSETS = [
  '/',
  '/index.html',
  '/about.html',
  '/manifesto.html',
  '/cronologia.html',
  '/contact.html',
  '/css/style.css',
  '/js/main.js',
  '/js/lang.js',
  '/404.html',
];

// Install: prime the cache with critical static assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(STATIC_ASSETS).catch(() => {}))
  );
  self.skipWaiting();
});

// Activate: clean old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((names) => Promise.all(
      names.filter((n) => n !== CACHE_NAME).map((n) => caches.delete(n))
    ))
  );
  self.clients.claim();
});

// Fetch: respond from cache when possible, then update in background
self.addEventListener('fetch', (event) => {
  const req = event.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  // Skip cross-origin and analytics
  if (url.origin !== location.origin) return;
  // Skip RSS, sitemap — always fresh
  if (url.pathname.endsWith('.rss') || url.pathname.endsWith('sitemap.xml')) return;

  const isHTML = req.destination === 'document' || url.pathname.endsWith('.html') || url.pathname === '/';

  if (isHTML) {
    // Stale-while-revalidate for HTML
    event.respondWith(
      caches.open(CACHE_NAME).then((cache) =>
        cache.match(req).then((cached) => {
          const network = fetch(req).then((res) => {
            if (res && res.status === 200) cache.put(req, res.clone());
            return res;
          }).catch(() => cached || cache.match('/404.html'));
          return cached || network;
        })
      )
    );
  } else {
    // Cache-first for static assets (CSS, JS, images, fonts)
    event.respondWith(
      caches.open(CACHE_NAME).then((cache) =>
        cache.match(req).then((cached) => {
          if (cached) return cached;
          return fetch(req).then((res) => {
            if (res && res.status === 200 && res.type === 'basic') {
              cache.put(req, res.clone());
            }
            return res;
          }).catch(() => cached);
        })
      )
    );
  }
});
