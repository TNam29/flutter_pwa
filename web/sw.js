const CACHE_NAME = 'recipe-book-v1';
const ASSETS_TO_CACHE = [
  '/',
  'index.html',
  'main.dart.js',
  'favicon.png',
  'icons/Icon-192.png',
  'icons/Icon-512.png',
];

self.addEventListener('install', (event) => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(ASSETS_TO_CACHE))
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys
          .filter((k) => k !== CACHE_NAME)
          .map((k) => caches.delete(k))
      )
    )
  );
});

// Simple fetch handler: try network then fallback to cache for navigation and API,
// cache-first for app shell assets.
self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // For same-origin navigations, use network-first
  if (request.mode === 'navigate') {
    event.respondWith(
      fetch(request)
        .then((response) => {
          caches.open(CACHE_NAME).then((cache) => cache.put(request, response.clone()));
          return response;
        })
        .catch(() => caches.match(request).then((res) => res || caches.match('index.html')))
    );
    return;
  }

  // For other requests, try cache first
  event.respondWith(
    caches.match(request).then((cached) => cached || fetch(request).then((response) => {
      // Optionally cache fetched assets
      if (request.url.startsWith(self.location.origin)) {
        caches.open(CACHE_NAME).then((cache) => cache.put(request, response.clone()));
      }
      return response;
    }).catch(() => cached))
  );
});
