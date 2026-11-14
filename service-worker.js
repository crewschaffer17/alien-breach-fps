// Minimal PWA install support. Do not cache game files or interfere with updates.
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', event => event.waitUntil(self.clients.claim()));
