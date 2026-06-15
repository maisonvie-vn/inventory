import re

page_path = r'd:\Invenroty\maison-vie-crm\src\app\page.tsx'

with open(page_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Update imports
print("1. Updating imports...")
old_import = "import React, { useState, useMemo } from 'react';"
new_import = "import React, { useState, useMemo, useEffect } from 'react';\nimport { supabase, isSupabaseConfigured } from '../lib/supabaseClient';"
if old_import in content:
    content = content.replace(old_import, new_import)
else:
    print("Could not find old import statement!")

# 2. Update state declarations
print("2. Adding auth states...")
old_state_target = "  const [salesData, setSalesData] = useState<SaleRecord[]>(getSales());"
new_state_insert = """  const [salesData, setSalesData] = useState<SaleRecord[]>(getSales());

  // Auth states
  const [currentUser, setCurrentUser] = useState<{ email: string; name?: string; role: string } | null>(null);
  const [authEmail, setAuthEmail] = useState('');
  const [authPassword, setAuthPassword] = useState('');
  const [isAuthLoading, setIsAuthLoading] = useState(false);
  const [authError, setAuthError] = useState('');"""
if old_state_target in content:
    content = content.replace(old_state_target, new_state_insert)
else:
    print("Could not find old state target!")

# 3. Add auth functions & useEffect after tab routing useEffect
print("3. Adding auth hooks & handlers...")
old_effect = """  React.useEffect(() => {
    const tabs: ('dashboard' | 'sales' | 'inventory' | 'recipes' | 'stockcount' | 'subrecipes')[] = [
      'dashboard', 'sales', 'inventory', 'recipes', 'stockcount', 'subrecipes'
    ];
    if (!hasTabAccess(userRole, activeTab)) {
      const firstAccessible = tabs.find(t => hasTabAccess(userRole, t));
      if (firstAccessible) {
        setActiveTab(firstAccessible);
      }
    }
  }, [userRole]);"""

new_effect_and_auth = """  React.useEffect(() => {
    const tabs: ('dashboard' | 'sales' | 'inventory' | 'recipes' | 'stockcount' | 'subrecipes')[] = [
      'dashboard', 'sales', 'inventory', 'recipes', 'stockcount', 'subrecipes'
    ];
    if (!hasTabAccess(userRole, activeTab)) {
      const firstAccessible = tabs.find(t => hasTabAccess(userRole, t));
      if (firstAccessible) {
        setActiveTab(firstAccessible);
      }
    }
  }, [userRole]);

  // Load session and profile on mount
  useEffect(() => {
    const checkSession = async () => {
      if (isSupabaseConfigured()) {
        const { data: { session } } = await supabase.auth.getSession();
        if (session) {
          // Fetch profile from supabase profiles table
          const { data: profile } = await supabase
            .from('profiles')
            .select('role, full_name')
            .eq('id', session.user.id)
            .single();
          
          const role = (profile?.role || 'admin') as any;
          setCurrentUser({
            email: session.user.email || '',
            name: profile?.full_name || session.user.email || '',
            role: role
          });
          setUserRole(role);
        }
      } else {
        // Fallback to localStorage sandbox user
        const localUser = localStorage.getItem('mv_local_user');
        if (localUser) {
          try {
            const parsed = JSON.parse(localUser);
            setCurrentUser(parsed);
            setUserRole(parsed.role);
          } catch (e) {
            console.error("Error parsing local user", e);
          }
        }
      }
    };

    checkSession();

    // Listen for auth changes if Supabase is configured
    if (isSupabaseConfigured()) {
      const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
        if (session) {
          const { data: profile } = await supabase
            .from('profiles')
            .select('role, full_name')
            .eq('id', session.user.id)
            .single();
          
          const role = (profile?.role || 'admin') as any;
          setCurrentUser({
            email: session.user.email || '',
            name: profile?.full_name || session.user.email || '',
            role: role
          });
          setUserRole(role);
        } else {
          setCurrentUser(null);
        }
      });
      return () => subscription.unsubscribe();
    }
  }, []);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsAuthLoading(true);
    setAuthError('');

    if (isSupabaseConfigured()) {
      const { data, error } = await supabase.auth.signInWithPassword({
        email: authEmail,
        password: authPassword
      });

      if (error) {
        setAuthError(error.message);
        setIsAuthLoading(false);
      } else if (data.user) {
        const { data: profile } = await supabase
          .from('profiles')
          .select('role, full_name')
          .eq('id', data.user.id)
          .single();
        
        const role = (profile?.role || 'admin') as any;
        setCurrentUser({
          email: data.user.email || '',
          name: profile?.full_name || data.user.email || '',
          role: role
        });
        setUserRole(role);
        setIsAuthLoading(false);
      }
    } else {
      // Sandbox mode login
      // We map certain emails to roles for simulation
      let role: any = 'admin';
      let name = 'Quản trị viên (CFO)';

      if (authEmail.includes('manager')) {
        role = 'restaurant_manager';
        name = 'Quản lý Nhà hàng';
      } else if (authEmail.includes('chef') && !authEmail.includes('sous')) {
        role = 'head_chef';
        name = 'Bếp trưởng';
      } else if (authEmail.includes('senior')) {
        role = 'senior_accountant';
        name = 'Kế toán kho cấp cao';
      } else if (authEmail.includes('foh') || authEmail.includes('supervisor')) {
        role = 'foh_supervisor';
        name = 'Giám sát Sảnh';
      } else if (authEmail.includes('sous') || authEmail.includes('phó')) {
        role = 'sous_chef';
        name = 'Bếp phó';
      } else if (authEmail.includes('junior') || authEmail.includes('store')) {
        role = 'junior_accountant';
        name = 'Thủ kho / Kế toán phụ';
      }

      const dummyUser = { email: authEmail, name, role };
      localStorage.setItem('mv_local_user', JSON.stringify(dummyUser));
      setCurrentUser(dummyUser);
      setUserRole(role);
      setIsAuthLoading(false);
    }
  };

  const handleLogout = async () => {
    if (isSupabaseConfigured()) {
      await supabase.auth.signOut();
    } else {
      localStorage.removeItem('mv_local_user');
    }
    setCurrentUser(null);
  };"""

if old_effect in content:
    content = content.replace(old_effect, new_effect_and_auth)
else:
    # Try normalizing spaces
    normalized_old = re.sub(r'\s+', ' ', old_effect).strip()
    normalized_content = re.sub(r'\s+', ' ', content)
    if normalized_old in normalized_content:
        print("Found effect in normalized content, but exact match failed due to whitespace differences. Trying regex replace...")
        # Since it's clean, we can replace the clean one directly using exact search in file
        content = re.sub(r'React\.useEffect\(\(\)\s*=>\s*\{.*?\}\s*,\s*\[userRole\]\s*\);', new_effect_and_auth, content, flags=re.DOTALL)
    else:
        print("Could not find old effect hook!")

# 4. Replace the return block and header
print("4. Updating return block and Header...")

# We will locate `return (` and its matching header block
# Let's target the exact return statement from the clean page.tsx:
old_return_header = """  return (
    <div className="min-h-screen flex flex-col bg-[#090d16] text-gray-100 selection:bg-amber-500 selection:text-black">
      {/* 1. Header (High-End French Neoclassical Styling) */}
      <header className="border-b border-amber-500/20 bg-[#0c1220]/80 backdrop-blur-md sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-6 py-4 flex flex-col md:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="relative w-10 h-10 border border-amber-500/50 flex items-center justify-center rounded-sm rotate-45 bg-[#090d16]">
              <span className="text-amber-500 font-serif font-semibold text-lg rotate-[-45deg] scale-90">MV</span>
            </div>
            <div>
              <h1 className="text-2xl font-semibold tracking-widest text-[#d4af37]">MAISON VIE</h1>
              <p className="text-[10px] tracking-[0.2em] text-gray-400 font-sans uppercase">Inventory CRM & Finance Controller</p>
            </div>
          </div>

          <div className="flex flex-wrap items-center gap-4">
            {/* Simulated Time & WAC Control */}
            <div className="flex items-center gap-2 bg-[#0c1220] border border-amber-500/20 px-3 py-1.5 rounded-sm">
              <span className="text-[10px] text-gray-400 font-sans uppercase">Giờ hệ thống:</span>
              <select 
                value={simulatedTime}
                onChange={(e) => {
                  setSimulatedTime(e.target.value);
                  const [hours, mins] = e.target.value.split(':').map(Number);
                  if (hours > 18 || (hours === 18 && mins >= 30)) {
                    setIsWacLocked(true);
                  } else {
                    setIsWacLocked(false);
                  }
                }}
                className="bg-transparent border-none text-xs font-mono text-amber-500 focus:outline-none cursor-pointer font-bold"
              >
                <option value="08:00" className="bg-[#090d16] text-gray-300">08:00 (Nhập kho)</option>
                <option value="12:00" className="bg-[#090d16] text-gray-300">12:00 (Trưa)</option>
                <option value="17:00" className="bg-[#090d16] text-gray-300">17:00 (Chiều)</option>
                <option value="18:30" className="bg-[#090d16] text-gray-300">18:30 (Chốt WAC)</option>
                <option value="22:30" className="bg-[#090d16] text-gray-300">22:30 (Trừ kho POS)</option>
                <option value="23:00" className="bg-[#090d16] text-gray-300">23:00 (Đóng cửa)</option>
              </select>
            </div>

            {/* Role Switcher */}
            <div className="flex items-center gap-2 bg-[#0c1220] border border-amber-500/20 px-3 py-1.5 rounded-sm">
              <span className="text-[10px] text-gray-400 font-sans uppercase">Vai trò:</span>
              <select 
                value={userRole}
                onChange={(e) => setUserRole(e.target.value as any)}
                className="bg-transparent border-none text-xs text-[#d4af37] focus:outline-none cursor-pointer font-semibold"
              >
                <option value="admin" className="bg-[#090d16] text-gray-300">Cấp 1: Admin (CFO/Owner)</option>
                <option value="restaurant_manager" className="bg-[#090d16] text-gray-300">Cấp 2: Quản lý Nhà hàng</option>
                <option value="head_chef" className="bg-[#090d16] text-gray-300">Cấp 3: Bếp trưởng</option>
                <option value="senior_accountant" className="bg-[#090d16] text-gray-300">Cấp 4: Kế toán kho cấp cao</option>
                <option value="foh_supervisor" className="bg-[#090d16] text-gray-300">Cấp 5: Giám sát (FOH)</option>
                <option value="sous_chef" className="bg-[#090d16] text-gray-300">Cấp 6: Bếp phó</option>
                <option value="junior_accountant" className="bg-[#090d16] text-gray-300">Cấp 7: Thủ kho / Kế toán phụ</option>
              </select>
            </div>

            <div className="h-8 w-[1px] bg-amber-500/20 hidden sm:block"></div>
            <div className="flex items-center gap-2">
              <span className="w-2.5 h-2.5 bg-emerald-500 rounded-full animate-ping"></span>
              <span className="text-xs text-gray-300 font-medium">Bản phẳng đồng bộ (Sync)</span>
            </div>
          </div>
        </div>
      </header>"""

new_return_header = """  if (!currentUser) {
    return (
      <div className="min-h-screen flex flex-col bg-[#090d16] text-gray-100 selection:bg-amber-500 selection:text-black justify-center items-center p-6 relative overflow-hidden">
        {/* Decorative background glow */}
        <div className="absolute top-1/4 left-1/4 w-[40rem] h-[40rem] bg-[#d4af37]/5 rounded-full blur-[10rem] pointer-events-none"></div>
        <div className="absolute bottom-1/4 right-1/4 w-[35rem] h-[35rem] bg-blue-500/5 rounded-full blur-[10rem] pointer-events-none"></div>

        <div className="w-full max-w-md bg-[#0c1220]/80 border border-amber-500/30 rounded-md p-8 flex flex-col gap-6 shadow-2xl backdrop-blur-md relative z-10">
          <div className="flex flex-col items-center gap-3 text-center">
            <div className="relative w-12 h-12 border border-amber-500/60 flex items-center justify-center rounded-sm rotate-45 bg-[#090d16] mb-2">
              <span className="text-amber-500 font-serif font-semibold text-2xl rotate-[-45deg] scale-90">MV</span>
            </div>
            <h2 className="text-2xl font-semibold tracking-widest text-[#d4af37] font-serif">MAISON VIE</h2>
            <p className="text-[10px] tracking-[0.2em] text-gray-400 font-sans uppercase">Hệ thống CRM/ERP Inventory & Finance</p>
          </div>

          <form onSubmit={handleLogin} className="flex flex-col gap-4 font-sans">
            <div className="flex flex-col gap-1.5">
              <label className="text-xs text-gray-400">Email đăng nhập:</label>
              <input 
                type="email" 
                required
                value={authEmail}
                onChange={(e) => setAuthEmail(e.target.value)}
                placeholder="email@maisonvie.vn"
                className="bg-[#090d16] border border-amber-500/20 rounded-sm p-3 text-xs text-gray-200 focus:outline-none focus:border-amber-500 font-sans"
              />
            </div>

            <div className="flex flex-col gap-1.5">
              <label className="text-xs text-gray-400">Mật khẩu bảo mật:</label>
              <input 
                type="password" 
                required
                value={authPassword}
                onChange={(e) => setAuthPassword(e.target.value)}
                placeholder="••••••••"
                className="bg-[#090d16] border border-amber-500/20 rounded-sm p-3 text-xs text-gray-200 focus:outline-none focus:border-amber-500 font-sans"
              />
            </div>

            {authError && (
              <p className="text-xs text-rose-400 font-medium">{authError}</p>
            )}

            <button 
              type="submit"
              disabled={isAuthLoading}
              className="w-full bg-gradient-to-r from-amber-600 to-amber-500 hover:from-amber-500 hover:to-[#f3e5ab] text-[#090d16] font-bold text-xs py-3 rounded-sm transition-all shadow-md active:scale-95 cursor-pointer mt-2 flex items-center justify-center gap-2"
            >
              {isAuthLoading ? 'ĐANG ĐĂNG NHẬP...' : 'ĐĂNG NHẬP HỆ THỐNG'}
            </button>
          </form>

          {/* Sandbox login helper info */}
          <div className="border-t border-amber-500/10 pt-4 flex flex-col gap-3">
            <div className="flex items-center gap-1.5 text-amber-500/80">
              <AlertTriangle size={14} />
              <span className="text-[10px] uppercase font-bold tracking-wider">Local Sandbox Mode Enabled</span>
            </div>
            <p className="text-[10px] text-gray-400 leading-relaxed font-sans">
              Chưa phát hiện Supabase Environment Keys. Anh có thể click nhanh vào một trong các tài khoản mẫu dưới đây để đăng nhập và trải nghiệm tức thời 7 lớp phân quyền RLS:
            </p>
            <div className="grid grid-cols-2 gap-2 text-[9px] font-sans">
              <button 
                onClick={() => { setAuthEmail('admin@maisonvie.vn'); setAuthPassword('sandbox'); }}
                className="border border-gray-800 hover:border-amber-500/30 bg-[#090d16] p-2 text-left rounded text-gray-300 text-[10px]"
              >
                💼 CFO / Owner (Admin)
              </button>
              <button 
                onClick={() => { setAuthEmail('manager@maisonvie.vn'); setAuthPassword('sandbox'); }}
                className="border border-gray-800 hover:border-amber-500/30 bg-[#090d16] p-2 text-left rounded text-gray-300 text-[10px]"
              >
                📋 Quản lý Nhà hàng
              </button>
              <button 
                onClick={() => { setAuthEmail('headchef@maisonvie.vn'); setAuthPassword('sandbox'); }}
                className="border border-gray-800 hover:border-amber-500/30 bg-[#090d16] p-2 text-left rounded text-gray-300 text-[10px]"
              >
                👨‍🍳 Bếp trưởng
              </button>
              <button 
                onClick={() => { setAuthEmail('senior.accountant@maisonvie.vn'); setAuthPassword('sandbox'); }}
                className="border border-gray-800 hover:border-amber-500/30 bg-[#090d16] p-2 text-left rounded text-gray-300 text-[10px]"
              >
                📊 Kế toán cao cấp
              </button>
              <button 
                onClick={() => { setAuthEmail('souschef@maisonvie.vn'); setAuthPassword('sandbox'); }}
                className="border border-gray-800 hover:border-amber-500/30 bg-[#090d16] p-2 text-left rounded text-gray-300 text-[10px]"
              >
                🍳 Bếp phó
              </button>
              <button 
                onClick={() => { setAuthEmail('storekeeper@maisonvie.vn'); setAuthPassword('sandbox'); }}
                className="border border-gray-800 hover:border-amber-500/30 bg-[#090d16] p-2 text-left rounded text-gray-300 text-[10px]"
              >
                📦 Thủ kho / Kế toán phụ
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen flex flex-col bg-[#090d16] text-gray-100 selection:bg-amber-500 selection:text-black">
      {/* 1. Header (High-End French Neoclassical Styling) */}
      <header className="border-b border-amber-500/20 bg-[#0c1220]/80 backdrop-blur-md sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-6 py-4 flex flex-col md:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="relative w-10 h-10 border border-amber-500/50 flex items-center justify-center rounded-sm rotate-45 bg-[#090d16]">
              <span className="text-amber-500 font-serif font-semibold text-lg rotate-[-45deg] scale-90">MV</span>
            </div>
            <div>
              <h1 className="text-2xl font-semibold tracking-widest text-[#d4af37]">MAISON VIE</h1>
              <p className="text-[10px] tracking-[0.2em] text-gray-400 font-sans uppercase">Inventory CRM & Finance Controller</p>
            </div>
          </div>

          <div className="flex flex-wrap items-center gap-4">
            {/* User Profile Info & Log Out */}
            <div className="flex items-center gap-2 bg-[#0c1220] border border-amber-500/20 px-3 py-1.5 rounded-sm">
              <span className="text-[10px] text-gray-400 font-sans uppercase">Đăng nhập:</span>
              <span className="text-xs font-semibold text-gray-200">{currentUser.name || currentUser.email}</span>
              <button 
                onClick={handleLogout}
                className="text-[10px] text-rose-400 hover:text-rose-300 underline cursor-pointer ml-1 font-sans uppercase font-bold"
              >
                Thoát
              </button>
            </div>

            {/* Simulated Time & WAC Control */}
            <div className="flex items-center gap-2 bg-[#0c1220] border border-amber-500/20 px-3 py-1.5 rounded-sm">
              <span className="text-[10px] text-gray-400 font-sans uppercase">Giờ hệ thống:</span>
              <select 
                value={simulatedTime}
                onChange={(e) => {
                  setSimulatedTime(e.target.value);
                  const [hours, mins] = e.target.value.split(':').map(Number);
                  if (hours > 18 || (hours === 18 && mins >= 30)) {
                    setIsWacLocked(true);
                  } else {
                    setIsWacLocked(false);
                  }
                }}
                className="bg-transparent border-none text-xs font-mono text-amber-500 focus:outline-none cursor-pointer font-bold"
              >
                <option value="08:00" className="bg-[#090d16] text-gray-300">08:00 (Nhập kho)</option>
                <option value="12:00" className="bg-[#090d16] text-gray-300">12:00 (Trưa)</option>
                <option value="17:00" className="bg-[#090d16] text-gray-300">17:00 (Chiều)</option>
                <option value="18:30" className="bg-[#090d16] text-gray-300">18:30 (Chốt WAC)</option>
                <option value="22:30" className="bg-[#090d16] text-gray-300">22:30 (Trừ kho POS)</option>
                <option value="23:00" className="bg-[#090d16] text-gray-300">23:00 (Đóng cửa)</option>
              </select>
            </div>

            {/* Role Switcher - Chỉ hiển thị cho Admin hoặc khi chạy Local Sandbox để test phân quyền */}
            {(!isSupabaseConfigured() || userRole === 'admin') && (
              <div className="flex items-center gap-2 bg-[#0c1220] border border-amber-500/20 px-3 py-1.5 rounded-sm">
                <span className="text-[10px] text-gray-400 font-sans uppercase">Test vai trò:</span>
                <select 
                  value={userRole}
                  onChange={(e) => setUserRole(e.target.value as any)}
                  className="bg-transparent border-none text-xs text-[#d4af37] focus:outline-none cursor-pointer font-semibold"
                >
                  <option value="admin" className="bg-[#090d16] text-gray-300">Cấp 1: Admin (CFO/Owner)</option>
                  <option value="restaurant_manager" className="bg-[#090d16] text-gray-300">Cấp 2: Quản lý Nhà hàng</option>
                  <option value="head_chef" className="bg-[#090d16] text-gray-300">Cấp 3: Bếp trưởng</option>
                  <option value="senior_accountant" className="bg-[#090d16] text-gray-300">Cấp 4: Kế toán kho cấp cao</option>
                  <option value="foh_supervisor" className="bg-[#090d16] text-gray-300">Cấp 5: Giám sát (FOH)</option>
                  <option value="sous_chef" className="bg-[#090d16] text-gray-300">Cấp 6: Bếp phó</option>
                  <option value="junior_accountant" className="bg-[#090d16] text-gray-300">Cấp 7: Thủ kho / Kế toán phụ</option>
                </select>
              </div>
            )}
            <div className="h-8 w-[1px] bg-amber-500/20 hidden sm:block"></div>
            <div className="flex items-center gap-2">
              <span className="w-2.5 h-2.5 bg-emerald-500 rounded-full animate-ping"></span>
              <span className="text-xs text-gray-300 font-medium">Bản phẳng đồng bộ (Sync)</span>
            </div>
          </div>
        </div>
      </header>"""

if old_return_header in content:
    content = content.replace(old_return_header, new_return_header)
else:
    normalized_old_ret = re.sub(r'\s+', ' ', old_return_header).strip()
    normalized_content = re.sub(r'\s+', ' ', content)
    if normalized_old_ret in normalized_content:
        print("Found return header in normalized content. Replacing using regex...")
        # Since it is a long multi-line string, we replace it using regex for safety
        content = re.sub(r'return\s*\(\s*<div className="min-h-screen flex flex-col bg-\[#090d16\] text-gray-100 selection:bg-amber-500 selection:text-black">.*?<\/header>', new_return_header, content, flags=re.DOTALL)
    else:
        print("Could not find old return header!")

# Write updated content back
with open(page_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Finished patching page.tsx!")
