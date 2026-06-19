'use client';

import React, { useState, useMemo } from 'react';
import { 
  DollarSign, 
  Plus, 
  Trash2, 
  FileText, 
  ArrowLeftRight, 
  ClipboardList, 
  Calendar, 
  User, 
  TrendingUp, 
  ShieldAlert,
  ArrowRightLeft
} from 'lucide-react';
import UniversalSearch from './UniversalSearch';
import { supabase, isSupabaseConfigured } from '../../lib/supabaseClient';

interface ManualFormsProps {
  ingredients: any[];
  setIngredients: React.Dispatch<React.SetStateAction<any[]>>;
  goodsReceipts: any[];
  setGoodsReceipts: React.Dispatch<React.SetStateAction<any[]>>;
  salesData: any[];
  setSalesData: React.Dispatch<React.SetStateAction<any[]>>;
  transactions: any[];
  setTransactions: React.Dispatch<React.SetStateAction<any[]>>;
  wasteLogs: any[];
  setWasteLogs: React.Dispatch<React.SetStateAction<any[]>>;
  recipes: Record<string, any>;
  posMappings: Record<string, any>;
  currentUser: any;
  locations: any[];
}

export default function ManualForms({
  ingredients,
  setIngredients,
  goodsReceipts,
  setGoodsReceipts,
  salesData,
  setSalesData,
  transactions,
  setTransactions,
  wasteLogs,
  setWasteLogs,
  recipes,
  posMappings,
  currentUser,
  locations
}: ManualFormsProps) {
  const [activeTab, setActiveTab] = useState<'sale' | 'grn' | 'issue'>('sale');

  const refreshSupabaseData = async () => {
    if (!isSupabaseConfigured()) return;
    try {
      // 1. Fetch ingredients view
      const viewName = currentUser?.role === 'admin' ? 'v_inventory_finance' : 
                       currentUser?.role === 'senior_accountant' ? 'v_inventory_cost' : 'v_inventory_ops';
      
      const { data: ingData } = await supabase.from(viewName).select('*');
      if (ingData) {
        const mappedIngs = ingData.map(item => ({
          id: item.ingredient_id,
          code: item.ingredient_code || item.ingredient_id,
          fr_name: item.nom_fr || '',
          vi_name: item.ten_vi || '',
          en_name: '',
          category: item.category || 'Khác', 
          supplier_tier: 'A',
          unit: item.stock_uom || 'kg',
          price: item.wac_price || 0,
          yield_rate: 100.0,
          stock_uom: item.stock_uom,
          recipe_uom: item.recipe_uom,
          stock_to_recipe_factor: parseFloat(item.stock_to_recipe_factor) || 1,
          tolerance_percent: parseFloat(item.tolerance_percent) || 5.0,
          tare_weight_grams: parseFloat(item.tare_weight_grams) || 0
        }));
        setIngredients(mappedIngs);
      }

      // 2. Fetch goods receipts
      const { data: grnData } = await supabase.from('goods_receipts').select('*, grn_lines(*)');
      if (grnData) {
        const mappedGrns = grnData.map(grn => ({
          id: grn.id,
          poId: grn.po_id,
          poNumber: grn.po_id || '',
          supplierName: grn.supplier_id || 'Nhà cung cấp',
          invoiceNo: grn.invoice_no,
          invoiceAmount: grn.invoice_amount,
          fxRate: grn.fx_rate,
          duty: grn.duty,
          freight: grn.freight,
          status: grn.status,
          matchStatus: grn.match_status,
          date: grn.business_date || grn.created_at?.split('T')[0],
          lines: (grn.grn_lines || []).map((line: any) => ({
            ingredientId: line.ingredient_id,
            qtyReceived: line.qty_received,
            purchaseUom: line.purchase_uom,
            unitPriceFx: line.unit_price_fx,
            landedUnitCost: line.landed_unit_cost || line.unit_price_fx
          }))
        }));
        setGoodsReceipts(mappedGrns);
      }

      // 3. Fetch sales imports
      const { data: salesDbData } = await supabase.from('sales_imports').select('*, menu_items(id, name, sale_price)');
      if (salesDbData) {
        const mappedSales = salesDbData.map(sale => {
          const menuItem = sale.menu_items as any;
          return {
            code: sale.menu_item_id,
            name: menuItem?.name || `Món ${sale.menu_item_id}`,
            price: menuItem?.sale_price || (sale.qty_sold > 0 ? (sale.net_revenue / sale.qty_sold) : 0),
            qty: sale.qty_sold,
            total_before_discount: sale.net_revenue,
            discount: 0,
            discount_pct: 0,
            service_charge: 0,
            tax: 0,
            order_type: (sale.order_type || 'DINE_IN') as 'DINE_IN' | 'TAKEAWAY',
            mapping_status: (sale.mapping_status || 'MAPPED') as 'MAPPED' | 'UNMAPPED' | 'RESOLVED' | 'NO_STOCK_IMPACT'
          };
        });
        setSalesData(mappedSales);
      }

      // 4. Fetch inventory transactions
      const { data: txData } = await supabase.from('inventory_transactions').select('*');
      if (txData) {
        const mappedTxs = txData.map(tx => ({
          id: tx.id.toString(),
          ingredientId: tx.ingredient_id,
          type: tx.txn_type === 'IMPORT' ? 'import' : 
                tx.txn_type === 'WASTE' ? 'waste' : 
                tx.txn_type === 'TRANSFER_IN' ? 'transfer_in' : 
                tx.txn_type === 'TRANSFER_OUT' ? 'transfer_out' : 
                tx.txn_type === 'SALE_DEPLETION' ? 'sale_depletion' : 'consumption',
          qty: Math.abs(tx.qty),
          unit_price: tx.unit_cost || 0,
          status: tx.status as any,
          date: tx.business_date,
          note: tx.ref_table ? `${tx.txn_type}: ${tx.ref_table} ID ${tx.ref_id}` : tx.txn_type,
          txn_type: tx.txn_type,
          locationId: tx.location_id || 'MAIN_STORE'
        }));
        setTransactions(mappedTxs);
      }

      // 5. Fetch waste logs
      const { data: wasteData } = await supabase.from('waste_logs').select('*');
      if (wasteData) {
        const mappedWastes = wasteData.map(w => ({
          id: w.id,
          ingredientId: w.ingredient_id,
          qty: w.qty,
          reason: w.reason,
          status: w.status,
          is_processed: w.is_processed,
          createdBy: w.created_by || 'Staff',
          createdAt: w.created_at?.split('T')[0]
        }));
        setWasteLogs(mappedWastes);
      }
    } catch (err) {
      console.error("Lỗi đồng bộ dữ liệu Supabase:", err);
    }
  };

  // ==========================================
  // TAB 1: MANUAL SALE STATES
  // ==========================================
  const [manualSaleDate, setManualSaleDate] = useState(() => new Date().toISOString().split('T')[0]);
  const [manualSaleOrderType, setManualSaleOrderType] = useState<'DINE_IN' | 'TAKEAWAY'>('DINE_IN');
  const [manualSaleLines, setManualSaleLines] = useState<{ code: string; qty: number; price: number; name: string }[]>([]);
  const [selectedRecipe, setSelectedRecipe] = useState<any>(null);
  const [manualSaleQtyInput, setManualSaleQtyInput] = useState('');
  const [manualSalePriceInput, setManualSalePriceInput] = useState('');

  // Prepare recipe items for UniversalSearch
  const recipeSearchItems = useMemo(() => {
    return Object.entries(recipes).map(([code, r]) => ({
      id: code,
      code: code,
      vi_name: r.name,
      fr_name: r.notes || '',
      category: r.category || 'Món ăn',
      unit: 'phần',
      price: r.price
    }));
  }, [recipes]);

  const handleSelectRecipeForSale = (recItem: any) => {
    setSelectedRecipe(recItem);
    setManualSalePriceInput(recItem.price.toString());
  };

  const handleAddManualSaleLine = () => {
    if (!selectedRecipe) return;
    const qty = parseFloat(manualSaleQtyInput);
    const price = parseFloat(manualSalePriceInput) || 0;
    if (isNaN(qty) || qty <= 0) {
      alert('Vui lòng nhập số lượng hợp lệ!');
      return;
    }
    setManualSaleLines(prev => [
      ...prev,
      { code: selectedRecipe.code, qty, price, name: selectedRecipe.vi_name }
    ]);
    setSelectedRecipe(null);
    setManualSaleQtyInput('');
    setManualSalePriceInput('');
  };

  const handleRemoveManualSaleLine = (index: number) => {
    setManualSaleLines(prev => prev.filter((_, i) => i !== index));
  };

  const handleSaveManualSale = async (e: React.FormEvent) => {
    e.preventDefault();
    if (manualSaleLines.length === 0) {
      alert('Vui lòng thêm ít nhất một món ăn!');
      return;
    }

    // Duplicate check: check if date and item code already has sales data in salesData
    const dupes: string[] = [];
    manualSaleLines.forEach(line => {
      const exists = salesData.some(s => s.code === line.code && s.mapping_status === 'MAPPED');
      if (exists) {
        dupes.push(line.name || line.code);
      }
    });

    if (dupes.length > 0) {
      const confirmed = window.confirm(
        `CẢNH BÁO TRÙNG LẶP:\nMón ${dupes.join(', ')} đã có doanh số POS trong ngày hôm nay.\n\nBạn có chắc chắn muốn ghi đè/nhập thủ công thêm?`
      );
      if (!confirmed) return;
    }

    if (isSupabaseConfigured()) {
      try {
        const insertRows = manualSaleLines.map(line => {
          const matchedRecipe = posMappings[line.code];
          const mappingStatus = matchedRecipe ? 'MAPPED' : 'UNMAPPED';
          return {
            import_date: manualSaleDate,
            menu_item_id: line.code,
            qty_sold: Math.round(line.qty),
            net_revenue: line.price * line.qty,
            is_processed: false,
            void_qty: 0,
            comp_qty: 0,
            mapping_status: mappingStatus,
            order_type: manualSaleOrderType
          };
        });

        const { error } = await supabase.from('sales_imports').insert(insertRows);
        if (error) throw error;
        
        await refreshSupabaseData();
        setManualSaleLines([]);
        alert(`Đã lưu và tự động trừ kho thành công ${manualSaleLines.length} dòng doanh số trên Supabase!`);
        return;
      } catch (err: any) {
        console.error("Lỗi lưu Supabase:", err);
        alert(`Lỗi lưu Supabase: ${err.message}`);
        return;
      }
    }

    const newSales: any[] = [];
    const newTrans: any[] = [];

    manualSaleLines.forEach(line => {
      const matchedRecipe = posMappings[line.code];
      const mappingStatus = matchedRecipe ? 'MAPPED' : 'UNMAPPED';

      const newSaleLine = {
        code: line.code,
        name: line.name,
        price: line.price,
        qty: line.qty,
        total_before_discount: line.price * line.qty,
        discount: 0,
        discount_pct: 0,
        service_charge: 0,
        tax: 0,
        mapping_status: mappingStatus,
        order_type: manualSaleOrderType,
        import_date: manualSaleDate
      };
      newSales.push(newSaleLine);

      if (matchedRecipe) {
        const recipeCode = matchedRecipe.recipe;
        const type = matchedRecipe.type;

        if (type === 'beer') {
          const ing = ingredients.find(i => i.code === recipeCode || i.id === recipeCode);
          newTrans.push({
            id: `tx-msale-${Date.now()}-${recipeCode}`,
            ingredientId: ing?.id || recipeCode,
            type: 'sale_depletion',
            txn_type: 'SALE_DEPLETION',
            qty: line.qty,
            unit_cost: ing?.price || ing?.wac_price || 0,
            status: 'approved',
            date: manualSaleDate,
            locationId: 'BAR',
            note: `Bán lẻ thủ công (MANUAL_SALE): ${recipeCode}`,
            source: 'MANUAL_SALE',
            created_by: currentUser?.email || 'admin@maisonvie.vn'
          });
        } else if (type === 'alc') {
          const r = recipes[recipeCode];
          if (r && r.ingredients) {
            r.ingredients.forEach((ri: any) => {
              const ing = ingredients.find(i => i.id === ri.ing_id || i.code === ri.ing_id);
              const factor = ing?.stock_to_recipe_factor || 1;
              const deduction = (ri.qty_eff * line.qty * 1.10) / factor; // with 10% buffer
              newTrans.push({
                id: `tx-msale-${Date.now()}-${ri.ing_id}`,
                ingredientId: ing?.id || ri.ing_id,
                type: 'sale_depletion',
                txn_type: 'SALE_DEPLETION',
                qty: deduction,
                unit_cost: ing?.price || ing?.wac_price || 0,
                status: 'approved',
                date: manualSaleDate,
                locationId: ing?.category && ['Wine', 'Alcohol', 'beverage', 'Beverage'].includes(ing.category) ? 'BAR' : 'KITCHEN',
                note: `Bán lẻ thủ công (MANUAL_SALE): ${r.name || line.code}`,
                source: 'MANUAL_SALE',
                created_by: currentUser?.email || 'admin@maisonvie.vn'
              });
            });
          }
        }
      }
    });

    setSalesData(prev => [...newSales, ...prev]);
    setTransactions(prev => [...newTrans, ...prev]);
    setManualSaleLines([]);
    alert(`Đã lưu thành công ${newSales.length} dòng doanh số thủ công (Sandbox)!`);
  };

  // ==========================================
  // TAB 2: MANUAL GRN STATES
  // ==========================================
  const [manualGrnSupplier, setManualGrnSupplier] = useState('');
  const [manualGrnInvoiceNo, setManualGrnInvoiceNo] = useState('');
  const [manualGrnDate, setManualGrnDate] = useState(() => new Date().toISOString().split('T')[0]);
  const [manualGrnFreight, setManualGrnFreight] = useState('0');
  const [manualGrnDuty, setManualGrnDuty] = useState('0');
  const [manualGrnLines, setManualGrnLines] = useState<{ ingredientId: string; qty: number; unit: string; price: number; name: string; code: string }[]>([]);
  
  const [selectedGrnIng, setSelectedGrnIng] = useState<any>(null);
  const [manualGrnQtyInput, setManualGrnQtyInput] = useState('');
  const [manualGrnPriceInput, setManualGrnPriceInput] = useState('');

  const handleSelectIngredientForGrn = (ing: any) => {
    setSelectedGrnIng(ing);
    setManualGrnPriceInput(ing.price?.toString() || '0');
  };

  const handleAddManualGrnLine = () => {
    if (!selectedGrnIng) return;
    const qty = parseFloat(manualGrnQtyInput);
    const price = parseFloat(manualGrnPriceInput) || 0;
    if (isNaN(qty) || qty <= 0) {
      alert('Vui lòng nhập số lượng hợp lệ!');
      return;
    }
    const unit = selectedGrnIng.unit || selectedGrnIng.stock_uom || 'kg';
    setManualGrnLines(prev => [
      ...prev,
      { 
        ingredientId: selectedGrnIng.id, 
        qty, 
        unit, 
        price, 
        name: selectedGrnIng.vi_name, 
        code: selectedGrnIng.code 
      }
    ]);
    setSelectedGrnIng(null);
    setManualGrnQtyInput('');
    setManualGrnPriceInput('');
  };

  const handleRemoveManualGrnLine = (index: number) => {
    setManualGrnLines(prev => prev.filter((_, i) => i !== index));
  };

  // Deduplicate helper: Get theoretical current stock for moving WAC in client simulation
  const getTheoreticalStock = (ingId: string) => {
    // Sum all approved transactions for this ingredient
    return transactions
      .filter(t => t.ingredientId === ingId && t.status === 'approved')
      .reduce((sum, t) => {
        if (t.txn_type === 'IMPORT' || t.txn_type === 'TRANSFER_IN') {
          return sum + Math.abs(t.qty);
        } else {
          return sum - Math.abs(t.qty);
        }
      }, 0);
  };

  const handleSaveManualGrn = async (e: React.FormEvent) => {
    e.preventDefault();
    if (manualGrnLines.length === 0) {
      alert('Vui lòng thêm ít nhất một nguyên liệu!');
      return;
    }
    if (!manualGrnSupplier.trim() || !manualGrnInvoiceNo.trim()) {
      alert('Vui lòng nhập tên nhà cung cấp và số hóa đơn!');
      return;
    }

    // Deduplication check: supplier_id + invoiceNo
    const invoiceExists = goodsReceipts.some(
      g => g.invoiceNo.trim().toLowerCase() === manualGrnInvoiceNo.trim().toLowerCase()
    );
    if (invoiceExists) {
      alert(`LỖI TRÙNG HÓA ĐƠN:\nSố hóa đơn "${manualGrnInvoiceNo}" đã tồn tại trong hệ thống. Vui lòng kiểm tra lại.`);
      return;
    }

    const totalInvoiceCost = manualGrnLines.reduce((sum, line) => sum + (line.qty * line.price), 0);
    const freight = parseFloat(manualGrnFreight) || 0;
    const duty = parseFloat(manualGrnDuty) || 0;
    const totalExtra = freight + duty;

    if (isSupabaseConfigured()) {
      try {
        let supplierId = '90000000-0000-0000-0000-000000000001'; 
        const { data: supData } = await supabase
          .from('suppliers')
          .select('id')
          .ilike('name', `%${manualGrnSupplier.trim()}%`)
          .limit(1);
        if (supData && supData.length > 0) {
          supplierId = supData[0].id;
        }

        const { data: grnResult, error: grnErr } = await supabase
          .from('goods_receipts')
          .insert({
            supplier_id: supplierId,
            invoice_no: manualGrnInvoiceNo,
            invoice_amount: totalInvoiceCost + totalExtra,
            fx_rate: 1.0,
            duty,
            freight,
            status: 'pending',
            match_status: 'APPROVED',
            business_date: manualGrnDate
          })
          .select('id')
          .single();

        if (grnErr) throw grnErr;

        const grnLinesToInsert = manualGrnLines.map(line => ({
          grn_id: grnResult.id,
          ingredient_id: line.ingredientId,
          qty_received: line.qty,
          purchase_uom: line.unit,
          unit_price_fx: line.price
        }));

        const { error: linesErr } = await supabase.from('grn_lines').insert(grnLinesToInsert);
        if (linesErr) throw linesErr;

        const { error: approveErr } = await supabase
          .from('goods_receipts')
          .update({ status: 'approved' })
          .eq('id', grnResult.id);
        
        if (approveErr) throw approveErr;

        await refreshSupabaseData();
        setManualGrnLines([]);
        setManualGrnInvoiceNo('');
        setManualGrnSupplier('');
        setManualGrnFreight('0');
        setManualGrnDuty('0');
        alert(`Đã nhập kho và tự động phân bổ Landed Cost, Moving WAC thành công phiếu nhập ${manualGrnInvoiceNo} trên Supabase!`);
        return;
      } catch (err: any) {
        console.error("Lỗi lưu phiếu nhập Supabase:", err);
        alert(`Lỗi lưu phiếu nhập Supabase: ${err.message}`);
        return;
      }
    }

    const grnLinesCalculated = manualGrnLines.map(line => {
      const baseValue = line.qty * line.price;
      const proportion = totalInvoiceCost > 0 ? baseValue / totalInvoiceCost : 0;
      const allocatedExtra = proportion * totalExtra;
      const landedUnitCost = line.qty > 0 ? (baseValue + allocatedExtra) / line.qty : line.price;

      return {
        ingredientId: line.ingredientId,
        name: line.name,
        qtyReceived: line.qty,
        purchaseUom: line.unit,
        unitPriceFx: line.price,
        landedUnitCost: Math.round(landedUnitCost * 100) / 100
      };
    });

    const newGrn = {
      id: `grn-manual-${Date.now()}`,
      poId: '',
      poNumber: 'MANUAL_GRN',
      supplierName: manualGrnSupplier,
      invoiceNo: manualGrnInvoiceNo,
      invoiceAmount: totalInvoiceCost + totalExtra,
      fxRate: 1.0,
      duty,
      freight,
      status: 'approved',
      matchStatus: 'APPROVED',
      date: manualGrnDate,
      lines: grnLinesCalculated
    };

    const newTrans: any[] = [];
    const updatedIngredients = [...ingredients];

    grnLinesCalculated.forEach(line => {
      const ingIdx = updatedIngredients.findIndex(i => i.id === line.ingredientId);
      if (ingIdx !== -1) {
        const ing = updatedIngredients[ingIdx];
        const currentStock = getTheoreticalStock(ing.id);
        
        const adjustedCurrentStock = Math.max(currentStock, 0);
        const newWac = (adjustedCurrentStock + line.qtyReceived) > 0 
          ? (adjustedCurrentStock * (ing.price || ing.wac_price || 0) + line.qtyReceived * line.landedUnitCost) / (adjustedCurrentStock + line.qtyReceived)
          : line.landedUnitCost;
        
        updatedIngredients[ingIdx] = {
          ...ing,
          price: Math.round(newWac)
        };
      }

      newTrans.push({
        id: `tx-mgrn-${Date.now()}-${line.ingredientId}`,
        ingredientId: line.ingredientId,
        type: 'import',
        txn_type: 'IMPORT',
        qty: line.qtyReceived,
        unit_cost: line.landedUnitCost,
        status: 'approved',
        date: manualGrnDate,
        locationId: 'MAIN_STORE',
        note: `Nhập kho thủ công (MANUAL_GRN) HĐ: ${manualGrnInvoiceNo}`,
        source: 'MANUAL_GRN',
        created_by: currentUser?.email || 'admin@maisonvie.vn'
      });
    });

    setGoodsReceipts(prev => [newGrn, ...prev]);
    setTransactions(prev => [...newTrans, ...prev]);
    setIngredients(updatedIngredients);
    setManualGrnLines([]);
    setManualGrnInvoiceNo('');
    setManualGrnSupplier('');
    setManualGrnFreight('0');
    setManualGrnDuty('0');
    alert(`Đã lập và duyệt thành công phiếu nhập kho thủ công ${manualGrnInvoiceNo}! Cập nhật WAC của các nguyên liệu liên quan (Sandbox).`);
  };

  // ==========================================
  // TAB 3: MANUAL ISSUE STATES
  // ==========================================
  const [manualIssueDate, setManualIssueDate] = useState(() => new Date().toISOString().split('T')[0]);
  const [manualIssueReason, setManualIssueReason] = useState<'WASTE' | 'NON_SALE' | 'TRANSFER' | 'ADJUST'>('WASTE');
  const [manualIssueSrcLocation, setManualIssueSrcLocation] = useState<'MAIN_STORE' | 'BAR' | 'KITCHEN'>('MAIN_STORE');
  const [manualIssueDestLocation, setManualIssueDestLocation] = useState<'MAIN_STORE' | 'BAR' | 'KITCHEN'>('KITCHEN');
  const [manualIssueLines, setManualIssueLines] = useState<{ ingredientId: string; qty: number; note: string; name: string; code: string }[]>([]);
  
  const [selectedIssueIng, setSelectedIssueIng] = useState<any>(null);
  const [manualIssueQtyInput, setManualIssueQtyInput] = useState('');
  const [manualIssueNoteInput, setManualIssueNoteInput] = useState('');

  const handleSelectIngredientForIssue = (ing: any) => {
    setSelectedIssueIng(ing);
  };

  const handleAddManualIssueLine = () => {
    if (!selectedIssueIng) return;
    const qty = parseFloat(manualIssueQtyInput);
    if (isNaN(qty) || qty <= 0) {
      alert('Vui lòng nhập số lượng hợp lệ!');
      return;
    }
    setManualIssueLines(prev => [
      ...prev,
      { 
        ingredientId: selectedIssueIng.id, 
        qty, 
        note: manualIssueNoteInput || 'Xuất thủ công', 
        name: selectedIssueIng.vi_name, 
        code: selectedIssueIng.code 
      }
    ]);
    setSelectedIssueIng(null);
    setManualIssueQtyInput('');
    setManualIssueNoteInput('');
  };

  const handleRemoveManualIssueLine = (index: number) => {
    setManualIssueLines(prev => prev.filter((_, i) => i !== index));
  };

  const handleSaveManualIssue = async (e: React.FormEvent) => {
    e.preventDefault();
    if (manualIssueLines.length === 0) {
      alert('Vui lòng thêm ít nhất một mặt hàng!');
      return;
    }

    if (manualIssueReason === 'TRANSFER' && manualIssueSrcLocation === manualIssueDestLocation) {
      alert('Lỗi: Kho nguồn và kho đích phải khác nhau khi chuyển kho!');
      return;
    }

    if (isSupabaseConfigured()) {
      try {
        const { data: { user } } = await supabase.auth.getUser();
        const userId = user?.id || null;

        if (manualIssueReason === 'WASTE') {
          for (const line of manualIssueLines) {
            const { data: inserted, error: insertErr } = await supabase
              .from('waste_logs')
              .insert({
                ingredient_id: line.ingredientId,
                qty: line.qty,
                reason: line.note,
                status: 'pending_approval',
                is_processed: false,
                created_by: userId
              })
              .select('id')
              .single();
            if (insertErr) throw insertErr;

            const { error: updateErr } = await supabase
              .from('waste_logs')
              .update({ status: 'approved' })
              .eq('id', inserted.id);
            if (updateErr) throw updateErr;
          }
        } else if (manualIssueReason === 'NON_SALE') {
          const insertRows = manualIssueLines.map(line => {
            let cType: 'STAFF_MEAL' | 'COMP' | 'R&D' | 'TRAINING' | 'EVENT' = 'R&D';
            const noteUpper = line.note.toUpperCase();
            if (noteUpper.includes('CƠM') || noteUpper.includes('STAFF') || noteUpper.includes('NV')) {
              cType = 'STAFF_MEAL';
            } else if (noteUpper.includes('TẶNG') || noteUpper.includes('COMP')) {
              cType = 'COMP';
            } else if (noteUpper.includes('TRAIN') || noteUpper.includes('HỌC')) {
              cType = 'TRAINING';
            } else if (noteUpper.includes('TIỆC') || noteUpper.includes('EVENT') || noteUpper.includes('SỰ KIỆN')) {
              cType = 'EVENT';
            }
            return {
              ingredient_id: line.ingredientId,
              qty: line.qty,
              consumption_type: cType,
              business_date: manualIssueDate,
              note: line.note,
              created_by: userId
            };
          });

          const { error } = await supabase.from('non_sale_consumption').insert(insertRows);
          if (error) throw error;
        } else if (manualIssueReason === 'TRANSFER') {
          const txsToInsert: any[] = [];
          manualIssueLines.forEach(line => {
            const transferId = (typeof crypto !== 'undefined' && crypto.randomUUID) ? crypto.randomUUID() : 'tr-' + Math.random().toString(36).substring(2, 15);
            const ing = ingredients.find(i => i.id === line.ingredientId);
            const price = ing?.price || ing?.wac_price || 0;

            // Leg OUT
            txsToInsert.push({
              ingredient_id: line.ingredientId,
              txn_type: 'TRANSFER_OUT',
              qty: -line.qty,
              unit_cost: price,
              business_date: manualIssueDate,
              status: 'approved',
              location_id: manualIssueSrcLocation,
              note: `Chuyển kho nội bộ (Leg OUT): ${line.note}`,
              transfer_id: transferId,
              created_by: userId
            });

            // Leg IN
            txsToInsert.push({
              ingredient_id: line.ingredientId,
              txn_type: 'TRANSFER_IN',
              qty: line.qty,
              unit_cost: price,
              business_date: manualIssueDate,
              status: 'approved',
              location_id: manualIssueDestLocation,
              note: `Chuyển kho nội bộ (Leg IN): ${line.note}`,
              transfer_id: transferId,
              created_by: userId
            });
          });

          const { error } = await supabase.from('inventory_transactions').insert(txsToInsert);
          if (error) throw error;
        } else if (manualIssueReason === 'ADJUST') {
          const txsToInsert = manualIssueLines.map(line => {
            const ing = ingredients.find(i => i.id === line.ingredientId);
            const price = ing?.price || ing?.wac_price || 0;
            return {
              ingredient_id: line.ingredientId,
              txn_type: 'STOCK_TAKE_ADJ',
              qty: line.qty,
              unit_cost: price,
              business_date: manualIssueDate,
              status: 'approved',
              location_id: manualIssueSrcLocation,
              note: `Điều chỉnh số liệu (MANUAL_ISSUE): ${line.note}`,
              created_by: userId
            };
          });

          const { error } = await supabase.from('inventory_transactions').insert(txsToInsert);
          if (error) throw error;
        }

        await refreshSupabaseData();
        setManualIssueLines([]);
        alert(`Đã lưu giao dịch xuất kho thủ công thành công lên Supabase!`);
        return;
      } catch (err: any) {
        console.error("Lỗi lưu phiếu xuất kho Supabase:", err);
        alert(`Lỗi lưu phiếu xuất kho Supabase: ${err.message}`);
        return;
      }
    }

    const newTrans: any[] = [];
    const newWastes: any[] = [];

    manualIssueLines.forEach(line => {
      const ing = ingredients.find(i => i.id === line.ingredientId);
      const price = ing?.price || ing?.wac_price || 0;

      if (manualIssueReason === 'WASTE') {
        const newWasteLog = {
          id: `waste-manual-${Date.now()}-${line.ingredientId}`,
          ingredientId: line.ingredientId,
          vi_name: line.name,
          qty: line.qty,
          unit: ing?.unit || 'kg',
          reason: line.note,
          status: 'approved',
          is_processed: true,
          created_at: new Date(manualIssueDate).toISOString()
        };
        newWastes.push(newWasteLog);

        newTrans.push({
          id: `tx-missue-${Date.now()}-${line.ingredientId}`,
          ingredientId: line.ingredientId,
          type: 'waste',
          txn_type: 'WASTE',
          qty: line.qty,
          unit_cost: price,
          status: 'approved',
          date: manualIssueDate,
          locationId: manualIssueSrcLocation,
          note: `Hủy hỏng thủ công (MANUAL_ISSUE): ${line.note}`,
          source: 'MANUAL_ISSUE',
          created_by: currentUser?.email || 'admin@maisonvie.vn'
        });
      } else if (manualIssueReason === 'NON_SALE') {
        newTrans.push({
          id: `tx-missue-${Date.now()}-${line.ingredientId}`,
          ingredientId: line.ingredientId,
          type: 'consumption',
          txn_type: 'NON_SALE',
          qty: line.qty,
          unit_cost: price,
          status: 'approved',
          date: manualIssueDate,
          locationId: manualIssueSrcLocation,
          note: `Tiêu hao ngoài bán hàng (MANUAL_ISSUE): ${line.note}`,
          source: 'MANUAL_ISSUE',
          created_by: currentUser?.email || 'admin@maisonvie.vn'
        });
      } else if (manualIssueReason === 'TRANSFER') {
        const transferId = `transfer-manual-${Date.now()}`;
        // Leg OUT
        newTrans.push({
          id: `tx-missue-out-${Date.now()}-${line.ingredientId}`,
          ingredientId: line.ingredientId,
          type: 'transfer_out',
          txn_type: 'TRANSFER_OUT',
          qty: line.qty,
          unit_cost: price,
          status: 'approved',
          date: manualIssueDate,
          locationId: manualIssueSrcLocation,
          note: `Chuyển kho nội bộ (Leg OUT): ${line.note}`,
          source: 'MANUAL_ISSUE',
          created_by: currentUser?.email || 'admin@maisonvie.vn',
          transferId
        });
        // Leg IN
        newTrans.push({
          id: `tx-missue-in-${Date.now()}-${line.ingredientId}`,
          ingredientId: line.ingredientId,
          type: 'transfer_in',
          txn_type: 'TRANSFER_IN',
          qty: line.qty,
          unit_cost: price,
          status: 'approved',
          date: manualIssueDate,
          locationId: manualIssueDestLocation,
          note: `Chuyển kho nội bộ (Leg IN): ${line.note}`,
          source: 'MANUAL_ISSUE',
          created_by: currentUser?.email || 'admin@maisonvie.vn',
          transferId
        });
      } else if (manualIssueReason === 'ADJUST') {
        newTrans.push({
          id: `tx-missue-adj-${Date.now()}-${line.ingredientId}`,
          ingredientId: line.ingredientId,
          type: 'stock_take',
          txn_type: 'STOCK_TAKE_ADJ',
          qty: line.qty, // Could be positive or negative
          unit_cost: price,
          status: 'approved',
          date: manualIssueDate,
          locationId: manualIssueSrcLocation,
          note: `Điều chỉnh số liệu (MANUAL_ISSUE): ${line.note}`,
          source: 'MANUAL_ISSUE',
          created_by: currentUser?.email || 'admin@maisonvie.vn'
        });
      }
    });

    if (newWastes.length > 0) {
      setWasteLogs(prev => [...newWastes, ...prev]);
    }
    setTransactions(prev => [...newTrans, ...prev]);
    setManualIssueLines([]);
    alert(`Đã thực hiện xuất kho thủ công thành công (Sandbox)!`);
  };

  return (
    <div className="flex flex-col gap-6 bg-[#042726] p-6 rounded-lg border border-[#C9A581] font-sans text-[#FBF8F4]">
      {/* Header & Tabs */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 border-b border-[#C9A581]/40 pb-4">
        <div>
          <h3 className="text-xl font-serif text-[#A8884E] font-bold tracking-wide">Nhập Giao Dịch Thủ Công (Manual Entry ERP)</h3>
          <p className="text-xs text-gray-400 mt-1">
            Giao diện dành riêng cho nhập tay: Bán món ăn, Nhận hàng kho (GRN) & Xuất kho (Hủy hỏng / Điều chuyển).
          </p>
        </div>
        
        {/* Navigation Tabs */}
        <div className="flex items-center bg-[#102B2A] border border-[#C9A581]/40 rounded p-1 font-mono text-xs">
          <button
            onClick={() => setActiveTab('sale')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded transition-all active:scale-95 ${
              activeTab === 'sale' 
                ? 'bg-[#A8884E] text-[#042726] font-bold' 
                : 'text-[#FBF8F4] hover:text-[#C2A35A]'
            }`}
          >
            <DollarSign size={13} />
            <span>Bán Hàng</span>
          </button>
          <button
            onClick={() => setActiveTab('grn')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded transition-all active:scale-95 ${
              activeTab === 'grn' 
                ? 'bg-[#A8884E] text-[#042726] font-bold' 
                : 'text-[#FBF8F4] hover:text-[#C2A35A]'
            }`}
          >
            <Plus size={13} />
            <span>Nhập Kho (GRN)</span>
          </button>
          <button
            onClick={() => setActiveTab('issue')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded transition-all active:scale-95 ${
              activeTab === 'issue' 
                ? 'bg-[#A8884E] text-[#042726] font-bold' 
                : 'text-[#FBF8F4] hover:text-[#C2A35A]'
            }`}
          >
            <ArrowLeftRight size={13} />
            <span>Xuất / Chuyển Kho</span>
          </button>
        </div>
      </div>

      {/* ========================================================================= */}
      {/* TAB 1: MANUAL SALE FORM */}
      {/* ========================================================================= */}
      {activeTab === 'sale' && (
        <form onSubmit={handleSaveManualSale} className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-1 bg-[#102B2A]/40 border border-[#C9A581]/30 p-5 rounded flex flex-col gap-4">
            <div className="flex items-center gap-2 text-xs font-bold text-[#A8884E] uppercase border-b border-[#C9A581]/20 pb-2">
              <TrendingUp size={15} />
              <span>Thông tin chung</span>
            </div>

            <div className="flex flex-col gap-1.5">
              <label className="text-[10px] uppercase font-semibold text-gray-300">Ngày ghi nhận</label>
              <div className="relative">
                <input 
                  type="date"
                  value={manualSaleDate}
                  onChange={(e) => setManualSaleDate(e.target.value)}
                  className="w-full bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] p-2 rounded text-xs text-[#FBF8F4] font-mono focus:outline-none cursor-pointer"
                />
              </div>
            </div>

            <div className="flex flex-col gap-1.5">
              <label className="text-[10px] uppercase font-semibold text-gray-300">Kênh order_type</label>
              <select
                value={manualSaleOrderType}
                onChange={(e) => setManualSaleOrderType(e.target.value as any)}
                className="w-full bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] p-2 rounded text-xs text-[#FBF8F4] focus:outline-none cursor-pointer"
              >
                <option value="DINE_IN">Tại chỗ (DINE_IN)</option>
                <option value="TAKEAWAY">Mang về (TAKEAWAY - Auto trừ bao bì)</option>
              </select>
            </div>

            <div className="border border-[#C9A581]/30 p-4 rounded bg-[#102B2A]/60 flex flex-col gap-3 mt-2">
              <span className="text-[10px] font-bold text-[#A8884E] uppercase border-b border-[#C9A581]/20 pb-1">
                Thêm món vào hóa đơn
              </span>
              
              <div className="flex flex-col gap-1">
                <label className="text-[9px] uppercase text-gray-400">Chọn món ăn</label>
                <UniversalSearch 
                  ingredients={recipeSearchItems}
                  onSelect={handleSelectRecipeForSale}
                  placeholder="Gõ mã món (R1001, B5001...) hoặc tên..."
                />
              </div>

              {selectedRecipe && (
                <div className="bg-[#042726] border border-[#A8884E]/40 p-2.5 rounded text-[11px] text-[#FBF8F4] flex flex-col gap-1 animate-fadeIn">
                  <div>Đang chọn: <span className="font-bold text-[#C2A35A]">{selectedRecipe.code} - {selectedRecipe.vi_name}</span></div>
                  <div>Giá mặc định: <span className="font-mono text-[#62A57C]">{selectedRecipe.price.toLocaleString()}đ</span></div>
                </div>
              )}

              <div className="grid grid-cols-2 gap-2">
                <div className="flex flex-col gap-1">
                  <label className="text-[9px] uppercase text-gray-400">Số lượng</label>
                  <input 
                    type="number"
                    step="any"
                    placeholder="VD: 3"
                    value={manualSaleQtyInput}
                    onChange={(e) => setManualSaleQtyInput(e.target.value)}
                    className="bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] rounded p-2 text-xs text-[#FBF8F4] font-mono focus:outline-none"
                  />
                </div>
                <div className="flex flex-col gap-1">
                  <label className="text-[9px] uppercase text-gray-400">Đơn giá (đ)</label>
                  <input 
                    type="number"
                    placeholder="Giá override"
                    value={manualSalePriceInput}
                    onChange={(e) => setManualSalePriceInput(e.target.value)}
                    className="bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] rounded p-2 text-xs text-[#FBF8F4] font-mono focus:outline-none"
                  />
                </div>
              </div>

              <button
                type="button"
                onClick={handleAddManualSaleLine}
                disabled={!selectedRecipe || !manualSaleQtyInput}
                className="bg-[#0C201F] hover:bg-[#102B2A] border border-[#A8884E]/50 text-[#C2A35A] font-bold text-xs py-2 rounded transition-all cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed mt-1"
              >
                + Thêm món
              </button>
            </div>
          </div>

          <div className="lg:col-span-2 flex flex-col justify-between gap-4 bg-[#102B2A]/20 border border-[#C9A581]/30 p-5 rounded">
            <div className="flex flex-col gap-3">
              <h4 className="text-xs font-bold uppercase text-[#A8884E] border-b border-[#C9A581]/20 pb-2">
                Chi tiết hóa đơn bán hàng thủ công
              </h4>

              {manualSaleLines.length === 0 ? (
                <div className="text-center text-xs text-gray-500 italic py-16">
                  Chưa có món ăn nào trong danh sách. Vui lòng tìm và thêm ở form bên trái.
                </div>
              ) : (
                <div className="overflow-x-auto border border-[#C9A581]/30 rounded">
                  <table className="w-full text-xs text-left text-gray-300">
                    <thead className="bg-[#102B2A] font-mono text-[10px] text-gray-300 uppercase border-b border-[#C9A581]/40">
                      <tr>
                        <th className="px-3 py-2">Mã POS</th>
                        <th className="px-3 py-2">Tên món</th>
                        <th className="px-3 py-2 text-center">Số lượng</th>
                        <th className="px-3 py-2 text-right">Đơn giá</th>
                        <th className="px-3 py-2 text-right">Thành tiền</th>
                        <th className="px-3 py-2 text-center"></th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-[#C9A581]/20 font-sans">
                      {manualSaleLines.map((line, idx) => (
                        <tr key={idx} className="hover:bg-[#102B2A]/40 transition-colors">
                          <td className="px-3 py-2 font-mono text-[#C2A35A] font-bold">{line.code}</td>
                          <td className="px-3 py-2 font-medium">{line.name}</td>
                          <td className="px-3 py-2 text-center font-mono font-bold text-gray-100">{line.qty}</td>
                          <td className="px-3 py-2 text-right font-mono">{line.price.toLocaleString()}đ</td>
                          <td className="px-3 py-2 text-right font-mono text-[#62A57C] font-semibold">
                            {(line.price * line.qty).toLocaleString()}đ
                          </td>
                          <td className="px-3 py-2 text-center">
                            <button
                              type="button"
                              onClick={() => handleRemoveManualSaleLine(idx)}
                              className="text-red-400 hover:text-red-300 transition-colors cursor-pointer"
                            >
                              <Trash2 size={14} />
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </div>

            <div className="flex flex-col gap-2 border-t border-[#C9A581]/20 pt-4">
              <div className="flex justify-between items-center text-xs">
                <span className="text-gray-400">Tổng cộng giá trị hóa đơn:</span>
                <span className="text-base font-serif font-bold text-[#C2A35A]">
                  {manualSaleLines.reduce((sum, l) => sum + l.price * l.qty, 0).toLocaleString()}đ
                </span>
              </div>
              <button
                type="submit"
                disabled={manualSaleLines.length === 0}
                className="w-full bg-[#A8884E] hover:bg-[#8C6F3C] text-[#042726] font-bold py-2.5 rounded text-xs transition-all shadow-md active:scale-95 cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Ghi Sổ Doanh Số Thủ Công (MANUAL_SALE)
              </button>
            </div>
          </div>
        </form>
      )}

      {/* ========================================================================= */}
      {/* TAB 2: MANUAL GRN (GOODS RECEIPT NOTE) */}
      {/* ========================================================================= */}
      {activeTab === 'grn' && (
        <form onSubmit={handleSaveManualGrn} className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-1 bg-[#102B2A]/40 border border-[#C9A581]/30 p-5 rounded flex flex-col gap-4">
            <div className="flex items-center gap-2 text-xs font-bold text-[#A8884E] uppercase border-b border-[#C9A581]/20 pb-2">
              <ClipboardList size={15} />
              <span>Chứng từ đầu vào</span>
            </div>

            <div className="flex flex-col gap-1">
              <label className="text-[10px] uppercase font-semibold text-gray-300">Nhà cung cấp *</label>
              <input 
                type="text"
                placeholder="VD: Tổng kho Đa Lộc"
                value={manualGrnSupplier}
                onChange={(e) => setManualGrnSupplier(e.target.value)}
                required
                className="bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] p-2 rounded text-xs text-[#FBF8F4] focus:outline-none"
              />
            </div>

            <div className="flex flex-col gap-1">
              <label className="text-[10px] uppercase font-semibold text-gray-300">Số hóa đơn / Bill No *</label>
              <input 
                type="text"
                placeholder="VD: INV-DALOC-2200"
                value={manualGrnInvoiceNo}
                onChange={(e) => setManualGrnInvoiceNo(e.target.value)}
                required
                className="bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] p-2 rounded text-xs text-[#FBF8F4] font-mono focus:outline-none"
              />
            </div>

            <div className="grid grid-cols-2 gap-2">
              <div className="flex flex-col gap-1">
                <label className="text-[10px] uppercase font-semibold text-gray-300">Ngày nhận hàng</label>
                <input 
                  type="date"
                  value={manualGrnDate}
                  onChange={(e) => setManualGrnDate(e.target.value)}
                  className="bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] p-2 rounded text-xs text-[#FBF8F4] font-mono focus:outline-none"
                />
              </div>
              <div className="flex flex-col gap-1">
                <label className="text-[10px] uppercase font-semibold text-gray-300">Tỷ giá VND</label>
                <input 
                  type="number"
                  readOnly
                  value="1.0"
                  className="bg-[#102B2A]/50 border border-[#C9A581]/40 p-2 rounded text-xs text-gray-400 font-mono focus:outline-none cursor-not-allowed"
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-2">
              <div className="flex flex-col gap-1">
                <label className="text-[10px] uppercase font-semibold text-gray-300 text-amber-300">Cước vận chuyển (đ)</label>
                <input 
                  type="number"
                  placeholder="0"
                  value={manualGrnFreight}
                  onChange={(e) => setManualGrnFreight(e.target.value)}
                  className="bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] p-2 rounded text-xs text-[#FBF8F4] font-mono focus:outline-none"
                />
              </div>
              <div className="flex flex-col gap-1">
                <label className="text-[10px] uppercase font-semibold text-gray-300 text-amber-300">Thuế nhập khẩu (đ)</label>
                <input 
                  type="number"
                  placeholder="0"
                  value={manualGrnDuty}
                  onChange={(e) => setManualGrnDuty(e.target.value)}
                  className="bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] p-2 rounded text-xs text-[#FBF8F4] font-mono focus:outline-none"
                />
              </div>
            </div>

            <div className="border border-[#C9A581]/30 p-4 rounded bg-[#102B2A]/60 flex flex-col gap-3 mt-1">
              <span className="text-[10px] font-bold text-[#A8884E] uppercase border-b border-[#C9A581]/20 pb-1">
                Tìm & Thêm nguyên vật liệu
              </span>
              
              <div className="flex flex-col gap-1">
                <label className="text-[9px] uppercase text-gray-400">Nguyên liệu</label>
                <UniversalSearch 
                  ingredients={ingredients}
                  onSelect={handleSelectIngredientForGrn}
                  placeholder="Mã NVL (ING-001) hoặc tên..."
                />
              </div>

              {selectedGrnIng && (
                <div className="bg-[#042726] border border-[#A8884E]/40 p-2.5 rounded text-[11px] text-[#FBF8F4] flex flex-col gap-1 animate-fadeIn">
                  <div className="flex justify-between">
                    <span>Mã: <strong className="text-[#C2A35A]">{selectedGrnIng.code}</strong></span>
                    <span className="text-gray-400">ĐVT: {selectedGrnIng.unit || selectedGrnIng.stock_uom}</span>
                  </div>
                  <div className="truncate">Tên: <strong className="text-gray-100">{selectedGrnIng.vi_name}</strong></div>
                  <div>WAC hiện tại: <span className="font-mono text-[#62A57C]">{(selectedGrnIng.price || selectedGrnIng.wac_price || 0).toLocaleString()}đ</span></div>
                </div>
              )}

              <div className="grid grid-cols-2 gap-2">
                <div className="flex flex-col gap-1">
                  <label className="text-[9px] uppercase text-gray-400">Số lượng nhận</label>
                  <input 
                    type="number"
                    step="any"
                    placeholder="VD: 10"
                    value={manualGrnQtyInput}
                    onChange={(e) => setManualGrnQtyInput(e.target.value)}
                    className="bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] rounded p-2 text-xs text-[#FBF8F4] font-mono focus:outline-none"
                  />
                </div>
                <div className="flex flex-col gap-1">
                  <label className="text-[9px] uppercase text-gray-400">Đơn giá gốc (đ)</label>
                  <input 
                    type="number"
                    placeholder="Đơn giá"
                    value={manualGrnPriceInput}
                    onChange={(e) => setManualGrnPriceInput(e.target.value)}
                    className="bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] rounded p-2 text-xs text-[#FBF8F4] font-mono focus:outline-none"
                  />
                </div>
              </div>

              <button
                type="button"
                onClick={handleAddManualGrnLine}
                disabled={!selectedGrnIng || !manualGrnQtyInput}
                className="bg-[#0C201F] hover:bg-[#102B2A] border border-[#A8884E]/50 text-[#C2A35A] font-bold text-xs py-2 rounded transition-all cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed mt-1"
              >
                + Thêm vào phiếu
              </button>
            </div>
          </div>

          <div className="lg:col-span-2 flex flex-col justify-between gap-4 bg-[#102B2A]/20 border border-[#C9A581]/30 p-5 rounded">
            <div className="flex flex-col gap-3">
              <h4 className="text-xs font-bold uppercase text-[#A8884E] border-b border-[#C9A581]/20 pb-2">
                Chi tiết phiếu nhận hàng (GRN Lines)
              </h4>

              {manualGrnLines.length === 0 ? (
                <div className="text-center text-xs text-gray-500 italic py-24">
                  Phiếu trống. Vui lòng thêm các mặt hàng nhập từ bảng cấu hình bên trái.
                </div>
              ) : (
                <div className="overflow-x-auto border border-[#C9A581]/30 rounded">
                  <table className="w-full text-xs text-left text-gray-300">
                    <thead className="bg-[#102B2A] font-mono text-[10px] text-gray-300 uppercase border-b border-[#C9A581]/40">
                      <tr>
                        <th className="px-3 py-2">Mã NVL</th>
                        <th className="px-3 py-2">Tên nguyên liệu</th>
                        <th className="px-3 py-2 text-center">ĐVT</th>
                        <th className="px-3 py-2 text-right">SL Nhập</th>
                        <th className="px-3 py-2 text-right">Đơn giá gốc</th>
                        <th className="px-3 py-2 text-right text-emerald-400 font-bold">Landed Cost ước tính</th>
                        <th className="px-3 py-2 text-center"></th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-[#C9A581]/20 font-sans">
                      {manualGrnLines.map((line, idx) => {
                        const totalInvoiceCost = manualGrnLines.reduce((sum, l) => sum + (l.qty * l.price), 0);
                        const freight = parseFloat(manualGrnFreight) || 0;
                        const duty = parseFloat(manualGrnDuty) || 0;
                        const totalExtra = freight + duty;

                        const baseValue = line.qty * line.price;
                        const proportion = totalInvoiceCost > 0 ? baseValue / totalInvoiceCost : 0;
                        const allocatedExtra = proportion * totalExtra;
                        const landedCost = line.qty > 0 ? (baseValue + allocatedExtra) / line.qty : line.price;

                        return (
                          <tr key={idx} className="hover:bg-[#102B2A]/40 transition-colors">
                            <td className="px-3 py-2 font-mono text-[#C2A35A] font-bold">{line.code}</td>
                            <td className="px-3 py-2 font-medium">{line.name}</td>
                            <td className="px-3 py-2 text-center text-gray-400">{line.unit}</td>
                            <td className="px-3 py-2 text-center font-mono font-bold text-gray-100">{line.qty}</td>
                            <td className="px-3 py-2 text-right font-mono">{line.price.toLocaleString()}đ</td>
                            <td className="px-3 py-2 text-right font-mono text-emerald-400 font-bold">
                              {Math.round(landedCost).toLocaleString()}đ
                            </td>
                            <td className="px-3 py-2 text-center">
                              <button
                                type="button"
                                onClick={() => handleRemoveManualGrnLine(idx)}
                                className="text-red-400 hover:text-red-300 transition-colors cursor-pointer"
                              >
                                <Trash2 size={14} />
                              </button>
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                </div>
              )}
            </div>

            <div className="flex flex-col gap-2.5 border-t border-[#C9A581]/20 pt-4">
              <div className="grid grid-cols-2 gap-4 text-xs font-mono text-gray-300">
                <div className="flex justify-between">
                  <span>Tiền hàng gốc:</span>
                  <span>{manualGrnLines.reduce((sum, l) => sum + l.price * l.qty, 0).toLocaleString()}đ</span>
                </div>
                <div className="flex justify-between">
                  <span>Tổng phí + thuế phân bổ:</span>
                  <span>{((parseFloat(manualGrnFreight) || 0) + (parseFloat(manualGrnDuty) || 0)).toLocaleString()}đ</span>
                </div>
              </div>
              <div className="flex justify-between items-center text-xs mt-1">
                <span className="text-gray-400 uppercase font-bold">Tổng giá trị thanh toán chứng từ:</span>
                <span className="text-base font-serif font-bold text-emerald-400">
                  {(
                    manualGrnLines.reduce((sum, l) => sum + l.price * l.qty, 0) + 
                    (parseFloat(manualGrnFreight) || 0) + 
                    (parseFloat(manualGrnDuty) || 0)
                  ).toLocaleString()}đ
                </span>
              </div>
              
              <button
                type="submit"
                disabled={manualGrnLines.length === 0}
                className="w-full bg-emerald-600 hover:bg-emerald-700 text-[#FBF8F4] font-bold py-2.5 rounded text-xs transition-all shadow-md active:scale-95 cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Phê Duyệt & Ghi Kho Nhận (MANUAL_GRN)
              </button>
            </div>
          </div>
        </form>
      )}

      {/* ========================================================================= */}
      {/* TAB 3: MANUAL ISSUE (XUẤT KHO / HỦY HỎNG / ĐIỀU CHUYỂN) */}
      {/* ========================================================================= */}
      {activeTab === 'issue' && (
        <form onSubmit={handleSaveManualIssue} className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-1 bg-[#102B2A]/40 border border-[#C9A581]/30 p-5 rounded flex flex-col gap-4">
            <div className="flex items-center gap-2 text-xs font-bold text-[#A8884E] uppercase border-b border-[#C9A581]/20 pb-2">
              <User size={15} />
              <span>Nghiệp vụ xuất kho</span>
            </div>

            <div className="flex flex-col gap-1.5">
              <label className="text-[10px] uppercase font-semibold text-gray-300">Ngày xuất</label>
              <input 
                type="date"
                value={manualIssueDate}
                onChange={(e) => setManualIssueDate(e.target.value)}
                className="w-full bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] p-2 rounded text-xs text-[#FBF8F4] font-mono focus:outline-none"
              />
            </div>

            <div className="flex flex-col gap-1.5">
              <label className="text-[10px] uppercase font-semibold text-gray-300 text-amber-400">Lý do xuất kho (Bắt buộc) *</label>
              <select
                value={manualIssueReason}
                onChange={(e) => setManualIssueReason(e.target.value as any)}
                className="w-full bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] p-2 rounded text-xs text-[#FBF8F4] focus:outline-none cursor-pointer"
              >
                <option value="WASTE">Hao hụt / Hủy hỏng (WASTE)</option>
                <option value="NON_SALE">Tiêu hao ngoài bán hàng (Staff / Biếu / R&D)</option>
                <option value="TRANSFER">Điều chuyển kho nội bộ (TRANSFER)</option>
                <option value="ADJUST">Điều chỉnh chênh lệch chốt số (STOCK_TAKE_ADJ)</option>
              </select>
            </div>

            <div className="grid grid-cols-2 gap-2">
              <div className="flex flex-col gap-1">
                <label className="text-[10px] uppercase font-semibold text-gray-300">Từ kho (Nguồn)</label>
                <select
                  value={manualIssueSrcLocation}
                  onChange={(e) => setManualIssueSrcLocation(e.target.value as any)}
                  className="bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] p-2 rounded text-xs text-[#FBF8F4] focus:outline-none cursor-pointer"
                >
                  {locations.map(loc => (
                    <option key={loc.id} value={loc.id}>{loc.name}</option>
                  ))}
                </select>
              </div>
              <div className="flex flex-col gap-1">
                <label className={`text-[10px] uppercase font-semibold ${manualIssueReason === 'TRANSFER' ? 'text-emerald-400' : 'text-gray-500 opacity-50'}`}>
                  Đến kho (Đích)
                </label>
                <select
                  value={manualIssueDestLocation}
                  disabled={manualIssueReason !== 'TRANSFER'}
                  onChange={(e) => setManualIssueDestLocation(e.target.value as any)}
                  className={`p-2 rounded text-xs focus:outline-none ${
                    manualIssueReason === 'TRANSFER' 
                      ? 'bg-[#102B2A] border border-[#C9A581]/60 text-[#FBF8F4] cursor-pointer' 
                      : 'bg-[#102B2A]/30 border border-[#C9A581]/20 text-gray-500 cursor-not-allowed opacity-50'
                  }`}
                >
                  {locations.map(loc => (
                    <option key={loc.id} value={loc.id}>{loc.name}</option>
                  ))}
                </select>
              </div>
            </div>

            <div className="border border-[#C9A581]/30 p-4 rounded bg-[#102B2A]/60 flex flex-col gap-3 mt-1">
              <span className="text-[10px] font-bold text-[#A8884E] uppercase border-b border-[#C9A581]/20 pb-1">
                Chọn NVL xuất kho
              </span>
              
              <div className="flex flex-col gap-1">
                <label className="text-[9px] uppercase text-gray-400">Nguyên vật liệu</label>
                <UniversalSearch 
                  ingredients={ingredients}
                  onSelect={handleSelectIngredientForIssue}
                  placeholder="Mã NVL hoặc tên..."
                />
              </div>

              {selectedIssueIng && (
                <div className="bg-[#042726] border border-[#A8884E]/40 p-2.5 rounded text-[11px] text-[#FBF8F4] flex flex-col gap-1 animate-fadeIn">
                  <div className="flex justify-between">
                    <span>Mã: <strong className="text-[#C2A35A]">{selectedIssueIng.code}</strong></span>
                    <span className="text-gray-400">ĐVT: {selectedIssueIng.unit}</span>
                  </div>
                  <div className="truncate">Tên: <strong className="text-gray-100">{selectedIssueIng.vi_name}</strong></div>
                </div>
              )}

              <div className="grid grid-cols-1 gap-2">
                <div className="flex flex-col gap-1">
                  <label className="text-[9px] uppercase text-gray-400">Số lượng xuất</label>
                  <input 
                    type="number"
                    step="any"
                    placeholder="VD: 5.5"
                    value={manualIssueQtyInput}
                    onChange={(e) => setManualIssueQtyInput(e.target.value)}
                    className="bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] rounded p-2 text-xs text-[#FBF8F4] font-mono focus:outline-none"
                  />
                </div>
                <div className="flex flex-col gap-1">
                  <label className="text-[9px] uppercase text-gray-400">Ghi chú lý do chi tiết</label>
                  <input 
                    type="text"
                    placeholder="VD: Bếp hủy hỏng cá hồi..."
                    value={manualIssueNoteInput}
                    onChange={(e) => setManualIssueNoteInput(e.target.value)}
                    className="bg-[#102B2A] border border-[#C9A581]/60 focus:border-[#C2A35A] rounded p-2 text-xs text-[#FBF8F4] focus:outline-none"
                  />
                </div>
              </div>

              <button
                type="button"
                onClick={handleAddManualIssueLine}
                disabled={!selectedIssueIng || !manualIssueQtyInput}
                className="bg-[#0C201F] hover:bg-[#102B2A] border border-[#A8884E]/50 text-[#C2A35A] font-bold text-xs py-2 rounded transition-all cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed mt-1"
              >
                + Thêm vào danh sách xuất
              </button>
            </div>
          </div>

          <div className="lg:col-span-2 flex flex-col justify-between gap-4 bg-[#102B2A]/20 border border-[#C9A581]/30 p-5 rounded">
            <div className="flex flex-col gap-3">
              <h4 className="text-xs font-bold uppercase text-[#A8884E] border-b border-[#C9A581]/20 pb-2">
                Chi tiết danh sách hàng xuất kho (Issue Lines)
              </h4>

              {manualIssueLines.length === 0 ? (
                <div className="text-center text-xs text-gray-500 italic py-24">
                  Danh sách trống. Chọn nguyên liệu và thêm ở cột bên trái.
                </div>
              ) : (
                <div className="overflow-x-auto border border-[#C9A581]/30 rounded">
                  <table className="w-full text-xs text-left text-gray-300">
                    <thead className="bg-[#102B2A] font-mono text-[10px] text-gray-300 uppercase border-b border-[#C9A581]/40">
                      <tr>
                        <th className="px-3 py-2">Mã NVL</th>
                        <th className="px-3 py-2">Tên nguyên liệu</th>
                        <th className="px-3 py-2 text-center">SL Xuất</th>
                        <th className="px-3 py-2">Ghi chú / Chi tiết</th>
                        <th className="px-3 py-2 text-center"></th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-[#C9A581]/20 font-sans">
                      {manualIssueLines.map((line, idx) => (
                        <tr key={idx} className="hover:bg-[#102B2A]/40 transition-colors">
                          <td className="px-3 py-2 font-mono text-[#C2A35A] font-bold">{line.code}</td>
                          <td className="px-3 py-2 font-medium">{line.name}</td>
                          <td className="px-3 py-2 text-center font-mono font-bold text-rose-400">-{line.qty}</td>
                          <td className="px-3 py-2 text-gray-400 max-w-[200px] truncate">{line.note}</td>
                          <td className="px-3 py-2 text-center">
                            <button
                              type="button"
                              onClick={() => handleRemoveManualIssueLine(idx)}
                              className="text-red-400 hover:text-red-300 transition-colors cursor-pointer"
                            >
                              <Trash2 size={14} />
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </div>

            <div className="flex flex-col gap-2.5 border-t border-[#C9A581]/20 pt-4">
              <div className="bg-[#3A1B17]/20 border border-[#D06A5C]/20 p-3.5 rounded text-xs text-gray-300 flex items-start gap-2">
                <ShieldAlert size={16} className="text-rose-400 shrink-0 mt-0.5" />
                <div className="flex flex-col gap-1">
                  <span className="font-bold text-[#FBF8F4]">CẢNH BÁO QUẢN TRỊ KHO:</span>
                  <span>
                    {manualIssueReason === 'WASTE' && 'Hành động xuất WASTE sẽ tạo bản ghi waste_logs phê duyệt ngay và trừ kho trực tiếp.'}
                    {manualIssueReason === 'NON_SALE' && 'Món xuất NON_SALE (tiêu hao nội bộ) sẽ được hạch toán ngay vào giá trị hao hụt.'}
                    {manualIssueReason === 'TRANSFER' && `Hành động này sẽ sinh hai bút toán: Trừ kho nguồn (${manualIssueSrcLocation}) và cộng kho đích (${manualIssueDestLocation}).`}
                    {manualIssueReason === 'ADJUST' && 'Bút toán điều chỉnh sẽ ghi nhận chênh lệch kiểm kê (STOCK_TAKE_ADJ) và không thay đổi lịch sử chứng từ.'}
                  </span>
                </div>
              </div>
              <button
                type="submit"
                disabled={manualIssueLines.length === 0}
                className="w-full bg-[#A8884E] hover:bg-[#8C6F3C] text-[#042726] font-bold py-2.5 rounded text-xs transition-all shadow-md active:scale-95 cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Ghi Nhận Nghiệp Vụ Xuất Kho (MANUAL_ISSUE)
              </button>
            </div>
          </div>
        </form>
      )}
    </div>
  );
}
