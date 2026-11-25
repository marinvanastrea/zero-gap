/* ZERØ GAP service worker: keeps the app working with no internet.
   Bump VERSION (and APP_VERSION in index.html) with every change so phones pick up the update. */
const VERSION = 'zg-1.6.1';
const SHELL = ['./', './index.html', './manifest.webmanifest', './icons/icon-192.png', './icons/icon-512.png', './icons/apple-touch-icon.png', './fonts/exo2-latin.woff2'];

self.addEventListener('install', (e) => {
  e.waitUntil(caches.open(VERSION).then((c) => c.addAll(SHELL.map((u) => new Request(u, { cache: 'reload' })))));
});
self.addEventListener('activate', (e) => {
  e.waitUntil(caches.keys().then((keys) => Promise.all(keys.filter((k) => k !== VERSION).map((k) => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener('message', (e) => { if (e.data === 'skip-waiting') self.skipWaiting(); });
self.addEventListener('fetch', (e) => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.origin === self.location.origin) {
    if (req.mode === 'navigate') {
      e.respondWith(caches.open(VERSION).then((c) => c.match('./index.html')).then((r) => r || fetch(req)));
      return;
    }
    e.respondWith(caches.open(VERSION).then((c) => c.match(req, { ignoreSearch: true })).then((r) => r || fetch(req)));
  }
  // Everything else (the GitHub API for sync) goes straight to the network and is never cached.
});
