// public/sw.js — Service Worker cho Web Push (PWA)
// Đăng ký bởi useWebPush hook; nhận push từ Supabase Edge Function / pg_net

const CACHE_NAME = 'maison-vie-v3';

// Install: cache app shell
self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(clients.claim());
});

// Nhận push notification từ server
self.addEventListener('push', (event) => {
  if (!event.data) return;

  let data;
  try {
    data = event.data.json();
  } catch {
    data = { title: 'Maison Vie', body: event.data.text() };
  }

  const {
    title = 'Maison Vie',
    body = 'Có thông báo mới',
    badge_type = 'INFO',
    url = '/',
    ref_id,
    scope_location,
  } = data;

  // Icon và badge theo loại thông báo
  const icon = '/favicon.ico';
  const badgeIcon = '/favicon.ico';

  // Vibration pattern (2 lần rung ngắn)
  const vibrate = badge_type === 'PO_PENDING_APPROVAL' ? [200, 100, 200] :
                  badge_type === 'LOW_STOCK'           ? [300, 150, 300, 150, 300] :
                  badge_type === 'ESCALATION'          ? [500, 200, 500] :
                  [200];

  const notificationOptions = {
    body,
    icon,
    badge: badgeIcon,
    vibrate,
    tag: `mv-${badge_type}-${ref_id || Date.now()}`, // gom thông báo cùng loại
    renotify: badge_type === 'ESCALATION', // ESCALATION bắn lại dù đã có tag
    requireInteraction: badge_type === 'PO_PENDING_APPROVAL' || badge_type === 'ESCALATION',
    data: { url, badge_type, ref_id, scope_location },
    actions: badge_type === 'PO_PENDING_APPROVAL' ? [
      { action: 'view', title: '👁️ Xem PO' },
      { action: 'dismiss', title: '✖ Đóng' }
    ] : [
      { action: 'view', title: '👁️ Xem chi tiết' }
    ]
  };

  event.waitUntil(
    self.registration.showNotification(title, notificationOptions)
  );
});

// Xử lý khi user click notification
self.addEventListener('notificationclick', (event) => {
  event.notification.close();

  const { url, badge_type, ref_id } = event.notification.data || {};
  const targetUrl = url || '/';

  if (event.action === 'dismiss') return;

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      // Focus tab đang mở nếu có
      for (const client of clientList) {
        if (client.url.includes(self.location.origin) && 'focus' in client) {
          client.focus();
          // Gửi message để app navigate đến đúng tab
          client.postMessage({ type: 'NOTIFICATION_CLICK', badge_type, ref_id });
          return;
        }
      }
      // Mở tab mới nếu chưa có
      return clients.openWindow(targetUrl);
    })
  );
});

// Sync background (không dùng — không polling)
self.addEventListener('sync', () => {});
