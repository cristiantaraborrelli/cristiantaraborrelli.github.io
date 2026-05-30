// KILL-SWITCH: this Service Worker version self-unregisters and clears all caches.
// Reason: a previous SW version may be serving stale or broken cache on mobile.
self.addEventListener('install', (event) => { self.skipWaiting(); });
self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    const names = await caches.keys();
    await Promise.all(names.map((n) => caches.delete(n)));
    const regs = await self.registration.unregister();
    // Force all client tabs to reload so they see fresh content
    const clients = await self.clients.matchAll({ type: 'window' });
    for (const c of clients) {
      try { c.navigate(c.url); } catch (e) {}
    }
  })());
});
self.addEventListener('fetch', (event) => {
  // Bypass cache entirely - go straight to network
  return;
});
