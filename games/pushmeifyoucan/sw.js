var CACHE = 'pushmeifyoucan'

self.addEventListener('install', function (event) {
  event.waitUntil(
    caches.open(CACHE).then(function (cache) {
      return cache.addAll([
        'index.html',
        'js/pushmeifyoucan.js'
      ])
    })
  )
})

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.open(CACHE).then(function (cache) {
      return cache.match(event.request).then(function (response) {
        return response || fetch(event.request)
      })
    })
  )
})
