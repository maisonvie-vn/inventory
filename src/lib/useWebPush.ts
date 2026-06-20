'use client';

/**
 * useWebPush — Hook đăng ký Web Push PWA với Supabase
 * - Xin quyền notification 1 lần
 * - Đăng ký service worker
 * - Lưu subscription vào DB qua RPC upsert_push_subscription
 * - KHÔNG polling: chỉ đăng ký 1 lần khi login
 */

import { useEffect, useCallback, useRef } from 'react';
import { supabase, isSupabaseConfigured } from './supabaseClient';

// VAPID Public Key từ Supabase Edge Function (set trong env hoặc hardcode dev)
// Production: đặt vào NEXT_PUBLIC_VAPID_PUBLIC_KEY trong .env.local
const VAPID_PUBLIC_KEY = process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY || '';

function urlBase64ToUint8Array(base64String: string) {
  const padding = '='.repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
  const rawData = window.atob(base64);
  const outputArray = new Uint8Array(rawData.length);
  for (let i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}

export function useWebPush(userId: string | null | undefined) {
  const registrationRef = useRef<ServiceWorkerRegistration | null>(null);

  const subscribe = useCallback(async () => {
    if (!userId || !isSupabaseConfigured()) return;
    if (!('serviceWorker' in navigator) || !('PushManager' in window)) {
      console.warn('[WebPush] Not supported in this browser');
      return;
    }
    if (!VAPID_PUBLIC_KEY) {
      console.warn('[WebPush] VAPID public key not set — push disabled');
      return;
    }

    try {
      // Đăng ký service worker
      const reg = await navigator.serviceWorker.register('/sw.js', { scope: '/' });
      registrationRef.current = reg;

      // Xin quyền notification
      const permission = await Notification.requestPermission();
      if (permission !== 'granted') {
        console.info('[WebPush] Permission denied by user');
        return;
      }

      // Lấy hoặc tạo subscription
      let sub = await reg.pushManager.getSubscription();
      if (!sub) {
        sub = await reg.pushManager.subscribe({
          userVisibleOnly: true,
          applicationServerKey: urlBase64ToUint8Array(VAPID_PUBLIC_KEY),
        });
      }

      const subJson = sub.toJSON();
      const keys = subJson.keys || {};

      // Lưu vào Supabase
      await supabase.rpc('upsert_push_subscription', {
        p_endpoint: sub.endpoint,
        p_p256dh: keys.p256dh || '',
        p_auth: keys.auth || '',
        p_ua: navigator.userAgent.slice(0, 200),
      });

      console.info('[WebPush] Subscription registered ✅');
    } catch (err) {
      console.error('[WebPush] Registration failed:', err);
    }
  }, [userId]);

  const unsubscribe = useCallback(async () => {
    if (!registrationRef.current) return;
    try {
      const sub = await registrationRef.current.pushManager.getSubscription();
      if (sub) {
        await supabase.rpc('remove_push_subscription', { p_endpoint: sub.endpoint });
        await sub.unsubscribe();
      }
    } catch (err) {
      console.error('[WebPush] Unsubscribe error:', err);
    }
  }, []);

  useEffect(() => {
    if (userId) {
      subscribe();
    }
    // Lắng nghe message từ service worker (notification click)
    const handleMessage = (event: MessageEvent) => {
      if (event.data?.type === 'NOTIFICATION_CLICK') {
        // Dispatch custom event để page.tsx xử lý navigate
        window.dispatchEvent(new CustomEvent('mv_notification_click', { detail: event.data }));
      }
    };
    navigator.serviceWorker?.addEventListener('message', handleMessage);
    return () => {
      navigator.serviceWorker?.removeEventListener('message', handleMessage);
    };
  }, [userId, subscribe]);

  return { subscribe, unsubscribe };
}
