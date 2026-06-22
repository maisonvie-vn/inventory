'use client';

/**
 * useRealtimeBadges — Hook Supabase Realtime để nhận badge thông báo
 * - KHÔNG polling: websocket chỉ nhận event mới
 * - Trả về danh sách badges đang active cho user hiện tại
 * - State-derived: khi mở app, query DB lấy badges đang treo
 */

import { useEffect, useState, useCallback } from 'react';
import { supabase, isSupabaseConfigured } from './supabaseClient';

export interface NotificationBadge {
  id: string;
  badge_type: 'PO_PENDING_APPROVAL' | 'LOW_STOCK' | 'ESCALATION';
  ref_table: string;
  ref_id: string;
  scope_location: string | null;
  created_at: string;
  metadata: Record<string, any>;
}

// Synthesize a dual high-pitch "beep-beep" sound using Web Audio API
const playBeepBeep = () => {
  if (typeof window === 'undefined') return;
  try {
    const AudioContextClass = window.AudioContext || (window as any).webkitAudioContext;
    if (!AudioContextClass) return;
    const ctx = new AudioContextClass();
    
    // Beep 1
    const osc1 = ctx.createOscillator();
    const gain1 = ctx.createGain();
    osc1.connect(gain1);
    gain1.connect(ctx.destination);
    osc1.type = 'sine';
    osc1.frequency.value = 880; // A5 pitch
    gain1.gain.setValueAtTime(0, ctx.currentTime);
    gain1.gain.linearRampToValueAtTime(0.2, ctx.currentTime + 0.05);
    gain1.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.15);
    osc1.start(ctx.currentTime);
    osc1.stop(ctx.currentTime + 0.15);
    
    // Beep 2
    const osc2 = ctx.createOscillator();
    const gain2 = ctx.createGain();
    osc2.connect(gain2);
    gain2.connect(ctx.destination);
    osc2.type = 'sine';
    osc2.frequency.value = 880;
    gain2.gain.setValueAtTime(0, ctx.currentTime + 0.20);
    gain2.gain.linearRampToValueAtTime(0.2, ctx.currentTime + 0.25);
    gain2.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.35);
    osc2.start(ctx.currentTime + 0.20);
    osc2.stop(ctx.currentTime + 0.35);
  } catch (e) {
    console.error('[Badges] Play sound failed:', e);
  }
};

export function useRealtimeBadges(userId: string | null | undefined, userRole: string) {
  const [badges, setBadges] = useState<NotificationBadge[]>([]);
  const [loading, setLoading] = useState(false);

  // Fetch initial state (state-derived, không phải event-driven)
  const fetchBadges = useCallback(async () => {
    if (!userId || !isSupabaseConfigured()) return;
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('notification_badges')
        .select('*')
        .eq('user_id', userId)
        .eq('is_active', true)
        .order('created_at', { ascending: false });

      if (error) throw error;
      setBadges((data || []) as NotificationBadge[]);
    } catch (err) {
      console.error('[Badges] Fetch error:', err);
    } finally {
      setLoading(false);
    }
  }, [userId]);

  // Resolve (tắt nháy) 1 badge
  const resolveBadge = useCallback(async (badgeId: string) => {
    if (!isSupabaseConfigured()) return;
    try {
      await supabase
        .from('notification_badges')
        .update({ is_active: false, resolved_at: new Date().toISOString(), resolved_by: userId })
        .eq('id', badgeId);
      setBadges(prev => prev.filter(b => b.id !== badgeId));
    } catch (err) {
      console.error('[Badges] Resolve error:', err);
    }
  }, [userId]);

  // Resolve tất cả badge của 1 PO (khi manager duyệt xong)
  const resolveBadgesByRef = useCallback(async (refId: string) => {
    if (!isSupabaseConfigured()) return;
    try {
      await supabase
        .from('notification_badges')
        .update({ is_active: false, resolved_at: new Date().toISOString(), resolved_by: userId })
        .eq('ref_id', refId)
        .eq('user_id', userId);
      setBadges(prev => prev.filter(b => b.ref_id !== refId));
    } catch (err) {
      console.error('[Badges] ResolveByRef error:', err);
    }
  }, [userId]);

  useEffect(() => {
    if (!userId || !isSupabaseConfigured()) return;

    fetchBadges();

    // Supabase Realtime subscription — nhận INSERT/UPDATE trên notification_badges
    // RLS đảm bảo chỉ nhận row của chính mình
    const channel = supabase
      .channel(`badges-${userId}`)
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'notification_badges',
          filter: `user_id=eq.${userId}`,
        },
        (payload) => {
          if (payload.eventType === 'INSERT') {
            const newBadge = payload.new as NotificationBadge;
            if ((newBadge as any).is_active) {
              setBadges(prev => {
                const exists = prev.find(b => b.id === newBadge.id);
                if (exists) return prev;
                // Play "beep-beep" audio alert when a new PO is pending approval or escalated
                if (newBadge.badge_type === 'PO_PENDING_APPROVAL' || newBadge.badge_type === 'ESCALATION') {
                  playBeepBeep();
                }
                return [newBadge, ...prev];
              });
            }
          } else if (payload.eventType === 'UPDATE') {
            const updated = payload.new as any;
            if (!updated.is_active) {
              setBadges(prev => prev.filter(b => b.id !== updated.id));
            }
          } else if (payload.eventType === 'DELETE') {
            const deleted = payload.old as any;
            setBadges(prev => prev.filter(b => b.id !== deleted.id));
          }
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [userId, fetchBadges]);

  // Tính số badge đang treo theo loại (cho badge count trên sidebar)
  const pendingApprovalCount = badges.filter(b => b.badge_type === 'PO_PENDING_APPROVAL').length;
  const lowStockCount = badges.filter(b => b.badge_type === 'LOW_STOCK').length;
  const escalationCount = badges.filter(b => b.badge_type === 'ESCALATION').length;
  const totalCount = badges.length;

  return {
    badges,
    loading,
    totalCount,
    pendingApprovalCount,
    lowStockCount,
    escalationCount,
    resolveBadge,
    resolveBadgesByRef,
    refetch: fetchBadges,
  };
}
