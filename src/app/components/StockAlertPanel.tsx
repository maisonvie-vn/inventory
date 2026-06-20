'use client';

/**
 * StockAlertPanel — Panel cảnh báo tồn kho 3 mức (thời gian thực)
 * 
 * Hiển thị:
 * 🔴 OUT / CRITICAL — âm hoặc dưới safety stock
 * 🟠 REORDER — đủ dùng < lead time (dưới reorder_point)
 * 🟢 OK — ẩn
 *
 * Features:
 * - Gom nhóm (anti-fatigue) + debounce (ack)
 * - Scoped theo bộ phận (Bar thấy Bar, Bếp thấy Bếp)
 * - Supabase Realtime: khi inventory_transactions INSERT → reorder_point trigger → view cập nhật
 */

import React, { useState, useEffect, useCallback } from 'react';
import { AlertTriangle, CheckCircle, Package, RefreshCw, Bell, BellOff } from 'lucide-react';
import { supabase, isSupabaseConfigured } from '../../lib/supabaseClient';

interface StockAlert {
  ingredient_id: string;
  code: string;
  name: string;
  nom_fr: string;
  stock_uom: string;
  location_id: string;
  current_stock: number;
  reorder_point: number;
  safety_stock: number;
  avg_daily_usage: number;
  lead_time_days: number;
  alert_level: 'OUT' | 'CRITICAL' | 'REORDER';
  days_of_cover: number | null;
  acked_by: string | null;
}

interface StockAlertPanelProps {
  userRole: string;
  userLocationScope: string | null; // null = all, 'BAR', 'KITCHEN'
  onNavigateToPurchasing?: () => void;
}

const ALERT_COLORS = {
  OUT:      { bg: 'bg-[#3A1B17]', border: 'border-[#D06A5C]', text: 'text-[#D06A5C]', dot: '#D06A5C', label: '🔴 Hết hàng' },
  CRITICAL: { bg: 'bg-[#3A1B17]', border: 'border-[#D06A5C]', text: 'text-[#D06A5C]', dot: '#D06A5C', label: '🔴 Gần hết' },
  REORDER:  { bg: 'bg-[#3A2C13]', border: 'border-[#D8AA57]', text: 'text-[#D8AA57]', dot: '#D8AA57', label: '🟠 Cần đặt hàng' },
};

export default function StockAlertPanel({ userRole, userLocationScope, onNavigateToPurchasing }: StockAlertPanelProps) {
  const [alerts, setAlerts] = useState<StockAlert[]>([]);
  const [loading, setLoading] = useState(false);
  const [isExpanded, setIsExpanded] = useState(true);
  const [lastRefresh, setLastRefresh] = useState<Date | null>(null);

  const canAcknowledge = ['admin','restaurant_manager','senior_accountant','junior_accountant','head_chef','BAR_SUPERVISOR'].includes(userRole);

  const fetchAlerts = useCallback(async () => {
    if (!isSupabaseConfigured()) return;
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('v_stock_alerts_ops')
        .select('*')
        .order('alert_level', { ascending: true })
        .order('current_stock', { ascending: true });

      if (error) throw error;

      let filtered = (data || []) as StockAlert[];
      if (userLocationScope) {
        filtered = filtered.filter(a => a.location_id === userLocationScope);
      }
      setAlerts(filtered);
      setLastRefresh(new Date());
    } catch (err) {
      console.error('[StockAlerts] Fetch error:', err);
    } finally {
      setLoading(false);
    }
  }, [userLocationScope]);

  // Initial fetch
  useEffect(() => {
    fetchAlerts();
  }, [fetchAlerts]);

  // Supabase Realtime: nghe thay đổi trên stock_alert_acks (khi ack) → refetch
  // Và lắng nghe khi inventory_transactions thay đổi → trigger DB sẽ cập nhật view
  useEffect(() => {
    if (!isSupabaseConfigured()) return;

    const channel = supabase
      .channel('stock-alerts-realtime')
      .on('postgres_changes', {
        event: 'INSERT', schema: 'public', table: 'inventory_transactions'
      }, () => {
        // Debounce: chờ 1.5s để trigger DB tính xong reorder_point
        setTimeout(() => fetchAlerts(), 1500);
      })
      .on('postgres_changes', {
        event: '*', schema: 'public', table: 'stock_alert_acks'
      }, () => {
        fetchAlerts();
      })
      .subscribe();

    return () => { supabase.removeChannel(channel); };
  }, [fetchAlerts]);

  // Acknowledge 1 mặt hàng
  const handleAck = useCallback(async (ingredientId: string, locationId: string, alertLevel: string) => {
    if (!canAcknowledge || !isSupabaseConfigured()) return;
    try {
      await supabase.rpc('acknowledge_stock_alert', {
        p_ingredient_id: ingredientId,
        p_location_id: locationId,
        p_alert_level: alertLevel,
      });
      // Optimistic update
      setAlerts(prev => prev.filter(a =>
        !(a.ingredient_id === ingredientId && a.location_id === locationId && a.alert_level === alertLevel)
      ));
    } catch (err) {
      console.error('[StockAlerts] Ack error:', err);
    }
  }, [canAcknowledge]);

  // Acknowledge tất cả cùng mức
  const handleAckAll = useCallback(async (alertLevel: string) => {
    const toAck = alerts.filter(a => a.alert_level === alertLevel);
    for (const a of toAck) {
      await handleAck(a.ingredient_id, a.location_id, alertLevel);
    }
  }, [alerts, handleAck]);

  const criticalAlerts = alerts.filter(a => a.alert_level === 'OUT' || a.alert_level === 'CRITICAL');
  const reorderAlerts  = alerts.filter(a => a.alert_level === 'REORDER');

  if (alerts.length === 0 && !loading) {
    return (
      <div className="rounded-xl border border-[#1f4a3f] bg-[#0C201F] p-4 flex items-center gap-3">
        <CheckCircle className="text-[#62A57C] shrink-0" size={20} />
        <span className="text-[#62A57C] text-sm font-medium">Tất cả mặt hàng đủ tồn kho ✓</span>
      </div>
    );
  }

  return (
    <div className="rounded-xl border border-[#C9A581]/30 bg-[#042726] overflow-hidden">
      {/* Header */}
      <div
        className="flex items-center justify-between px-4 py-3 cursor-pointer select-none hover:bg-[#0d3330] transition-colors"
        onClick={() => setIsExpanded(e => !e)}
      >
        <div className="flex items-center gap-2">
          <AlertTriangle className="text-[#D06A5C]" size={18} />
          <span className="font-semibold text-[#FBF8F4]">Cảnh báo tồn kho</span>
          {alerts.length > 0 && (
            <span className="bg-[#D06A5C] text-white text-xs font-bold rounded-full px-2 py-0.5 min-w-[20px] text-center">
              {alerts.length}
            </span>
          )}
          {loading && <RefreshCw size={14} className="text-[#C9A581] animate-spin" />}
        </div>
        <div className="flex items-center gap-2 text-xs text-[#C9A581]">
          {lastRefresh && <span>{lastRefresh.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' })}</span>}
          <button
            onClick={(e) => { e.stopPropagation(); fetchAlerts(); }}
            className="p-1 rounded hover:bg-[#1f4a3f] transition-colors"
            title="Làm mới"
          >
            <RefreshCw size={12} />
          </button>
          <span className="text-[#A8884E]">{isExpanded ? '▲' : '▼'}</span>
        </div>
      </div>

      {isExpanded && (
        <div className="px-4 pb-4 space-y-3">
          {/* CRITICAL / OUT section */}
          {criticalAlerts.length > 0 && (
            <AlertSection
              title={`🔴 Nguy cấp / Hết hàng (${criticalAlerts.length} mặt hàng)`}
              alerts={criticalAlerts}
              colorClass={ALERT_COLORS.CRITICAL}
              canAcknowledge={canAcknowledge}
              onAck={handleAck}
              onAckAll={() => handleAckAll('CRITICAL')}
              onNavigateToPurchasing={onNavigateToPurchasing}
            />
          )}

          {/* REORDER section */}
          {reorderAlerts.length > 0 && (
            <AlertSection
              title={`🟠 Cần đặt hàng (${reorderAlerts.length} mặt hàng)`}
              alerts={reorderAlerts}
              colorClass={ALERT_COLORS.REORDER}
              canAcknowledge={canAcknowledge}
              onAck={handleAck}
              onAckAll={() => handleAckAll('REORDER')}
              onNavigateToPurchasing={onNavigateToPurchasing}
            />
          )}

          {/* Nút đặt hàng ngay */}
          {alerts.length > 0 && onNavigateToPurchasing && (
            <button
              onClick={onNavigateToPurchasing}
              className="w-full mt-2 px-4 py-2 bg-[#A8884E] hover:bg-[#8C6F3C] text-white rounded-lg text-sm font-medium transition-colors flex items-center justify-center gap-2"
            >
              <Package size={14} />
              Tạo đơn đặt hàng cho {alerts.length} mặt hàng
            </button>
          )}
        </div>
      )}
    </div>
  );
}

interface AlertSectionProps {
  title: string;
  alerts: StockAlert[];
  colorClass: typeof ALERT_COLORS['OUT'];
  canAcknowledge: boolean;
  onAck: (ingredientId: string, locationId: string, alertLevel: string) => void;
  onAckAll: () => void;
  onNavigateToPurchasing?: () => void;
}

function AlertSection({ title, alerts, colorClass, canAcknowledge, onAck, onAckAll, onNavigateToPurchasing }: AlertSectionProps) {
  return (
    <div>
      <div className="flex items-center justify-between mb-2">
        <span className={`text-xs font-bold ${colorClass.text}`}>{title}</span>
        {canAcknowledge && alerts.length > 1 && (
          <button
            onClick={onAckAll}
            className="text-xs text-[#C9A581] hover:text-[#FBF8F4] flex items-center gap-1 transition-colors"
            title="Đánh dấu tất cả đã biết"
          >
            <BellOff size={10} />
            Tắt tất cả
          </button>
        )}
      </div>
      <div className="space-y-1.5 max-h-48 overflow-y-auto pr-1">
        {alerts.map(alert => (
          <AlertRow
            key={`${alert.ingredient_id}-${alert.location_id}`}
            alert={alert}
            colorClass={colorClass}
            canAcknowledge={canAcknowledge}
            onAck={onAck}
          />
        ))}
      </div>
    </div>
  );
}

function AlertRow({ alert, colorClass, canAcknowledge, onAck }: {
  alert: StockAlert;
  colorClass: typeof ALERT_COLORS['OUT'];
  canAcknowledge: boolean;
  onAck: (ingredientId: string, locationId: string, alertLevel: string) => void;
}) {
  const locLabel = alert.location_id === 'BAR' ? '🍸 Bar' : alert.location_id === 'KITCHEN' ? '🍳 Bếp' : '📦 Kho';
  return (
    <div className={`rounded-lg border ${colorClass.border} ${colorClass.bg} px-3 py-2 flex items-center justify-between gap-2`}>
      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-1.5">
          <span className={`text-xs font-bold ${colorClass.text}`}>{alert.code}</span>
          <span className="text-[#C9A581] text-xs">{locLabel}</span>
        </div>
        <div className="text-[#FBF8F4] text-xs truncate">{alert.name}</div>
        <div className="flex items-center gap-2 mt-0.5">
          <span className="text-xs text-[#C9A581]">
            Tồn: <strong className={colorClass.text}>{alert.current_stock.toFixed(2)}</strong> {alert.stock_uom}
          </span>
          {alert.days_of_cover !== null && (
            <span className="text-xs text-[#C9A581]">
              · Đủ dùng: <strong>{alert.days_of_cover} ngày</strong> (lead {alert.lead_time_days}d)
            </span>
          )}
        </div>
      </div>
      {canAcknowledge && (
        <button
          onClick={() => onAck(alert.ingredient_id, alert.location_id, alert.alert_level)}
          className="shrink-0 p-1.5 rounded hover:bg-[#1f4a3f] text-[#C9A581] hover:text-[#FBF8F4] transition-colors"
          title="Đã biết (tắt cảnh báo này)"
        >
          <BellOff size={12} />
        </button>
      )}
    </div>
  );
}
