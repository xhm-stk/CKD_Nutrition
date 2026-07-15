import React, { createContext, useContext, useState, useEffect } from 'react';
import { FoodItem } from '../../domain/entities/FoodItem';
import { Meal } from '../../domain/entities/Meal';
import { DailyLog } from '../../domain/entities/DailyLog';
import { MealRepository } from '../../data/repositories/MealRepository';
import { useAuth } from './AuthContext';
import { calculateQuotas, NutrientQuota } from '../../domain/usecases/CalculateQuota';
import { supabase } from '../../data/datasources/SupabaseClient';

const mealRepo = new MealRepository();

export type Language = 'th' | 'en';

export const translations = {
  th: {
    appName: 'โภชนาการโรคไต CKD',
    login: 'เข้าสู่ระบบ',
    register: 'สมัครสมาชิก',
    email: 'อีเมล',
    password: 'รหัสผ่าน',
    confirmPassword: 'ยืนยันรหัสผ่าน',
    name: 'ชื่อ-นามสกุล',
    enterName: 'กรุณากรอกชื่อ-นามสกุล',
    enterEmail: 'กรุณากรอกอีเมล',
    invalidEmail: 'รูปแบบอีเมลไม่ถูกต้อง',
    enterPassword: 'กรุณากรอกรหัสผ่าน',
    confirmPasswordError: 'รหัสผ่านไม่ตรงกัน',
    passwordStrengthError: 'รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัวอักษร มีตัวเลขและตัวอักษรใหญ่',
    nationalId: 'เลขบัตรประชาชน 13 หลัก',
    nationalIdError: 'เลขบัตรประชาชนไม่ถูกต้อง',
    acceptPDPA: 'ฉันยอมรับนโยบายความเป็นส่วนตัวและข้อกำหนด (PDPA)',
    pdpaError: 'กรุณากดยอมรับเงื่อนไขนโยบายความเป็นส่วนตัว',
    registerSuccess: 'สมัครสมาชิกสำเร็จ!',
    loginSuccess: 'เข้าสู่ระบบสำเร็จ!',
    logout: 'ออกจากระบบ',
    deleteAccount: 'ลบบัญชีถาวร',
    confirmDelete: 'ยืนยันการลบบัญชี?',
    confirmDeleteDesc: 'ข้อมูลประวัติและบันทึกโภชนาการทั้งหมดของคุณจะถูกลบถาวรและไม่สามารถกู้คืนได้',
    cancel: 'ยกเลิก',
    save: 'บันทึก',
    protein: 'โปรตีน',
    potassium: 'โพแทสเซียม',
    sodium: 'โซเดียม',
    sugar: 'น้ำตาล',
    carb: 'คาร์บ',
    water: 'น้ำสะอาด',
    urine: 'ปัสสาวะ',
    weight: 'น้ำหนัก (กก.)',
    height: 'ส่วนสูง (ซม.)',
    gender: 'เพศ',
    male: 'ชาย',
    female: 'หญิง',
    ckdStage: 'ระยะโรคไต',
    saveSuccess: 'บันทึกสำเร็จ!',
    saveError: 'เกิดข้อผิดพลาดในการบันทึก',
    dashboard: 'แดชบอร์ด',
    history: 'ประวัติการทาน',
    profile: 'โปรไฟล์',
    logFood: 'บันทึกอาหาร',
    logWater: 'บันทึกดื่มน้ำ',
    logUrine: 'บันทึกปัสสาวะ',
    quickAdd: 'ปุ่มเพิ่มด่วน',
    customAdd: 'หรือระบุเอง (มล.)',
    enterAmount: 'ระบุปริมาณ',
    mealType: 'มื้ออาหาร',
    breakfast: 'มื้อเช้า',
    lunch: 'มื้อกลางวัน',
    dinner: 'มื้อเย็น',
    snack: 'มื้อว่าง',
    netBalance: 'สมดุลน้ำเข้า-ออก (Net Balance)',
    warningOver: 'สารอาหารบางตัวเกินโควต้าประจำวันแล้ว ระวังด้วยนะ!',
    warningNear: 'สารอาหารบางตัวใกล้เต็มโควต้าแล้ว (>= 80%) ระวังด้วยนะ!',
    noMealsToday: 'ยังไม่มีประวัติการทานในวันนี้',
    searchFood: 'ค้นหารายการอาหาร...',
    customFood: 'ระบุปริมาณอาหารที่ทาน (กรัม)',
    portionInfo: 'ปริมาณอ้างอิงต่อเสิร์ฟ:',
  },
  en: {
    appName: 'CKD Nutrition',
    login: 'Login',
    register: 'Sign Up',
    email: 'Email',
    password: 'Password',
    confirmPassword: 'Confirm Password',
    name: 'Full Name',
    enterName: 'Please enter your name',
    enterEmail: 'Please enter your email',
    invalidEmail: 'Invalid email format',
    enterPassword: 'Please enter your password',
    confirmPasswordError: 'Passwords do not match',
    passwordStrengthError: 'Password must be >= 8 chars with uppercase and numbers',
    nationalId: '13-Digit National ID',
    nationalIdError: 'Invalid National ID',
    acceptPDPA: 'I accept the Privacy Policy & terms (PDPA)',
    pdpaError: 'Please accept the privacy policy',
    registerSuccess: 'Registration successful!',
    loginSuccess: 'Login successful!',
    logout: 'Log Out',
    deleteAccount: 'Delete Account',
    confirmDelete: 'Permanently Delete Account?',
    confirmDeleteDesc: 'All your history and nutrition logs will be deleted forever.',
    cancel: 'Cancel',
    save: 'Save',
    protein: 'Protein',
    potassium: 'Potassium',
    sodium: 'Sodium',
    sugar: 'Sugar',
    carb: 'Carbs',
    water: 'Clean Water',
    urine: 'Urine Output',
    weight: 'Weight (kg)',
    height: 'Height (cm)',
    gender: 'Gender',
    male: 'Male',
    female: 'Female',
    ckdStage: 'CKD Stage',
    saveSuccess: 'Saved successfully!',
    saveError: 'Failed to save',
    dashboard: 'Dashboard',
    history: 'History',
    profile: 'Profile',
    logFood: 'Log Food',
    logWater: 'Log Water',
    logUrine: 'Log Urine',
    quickAdd: 'Quick Add',
    customAdd: 'Or specify amount (ml)',
    enterAmount: 'Enter amount',
    mealType: 'Meal Type',
    breakfast: 'Breakfast',
    lunch: 'Lunch',
    dinner: 'Dinner',
    snack: 'Snack',
    netBalance: 'Water Net Balance',
    warningOver: 'Some nutrients have exceeded the daily limit!',
    warningNear: 'Some nutrients are near the daily limit (>= 80%)!',
    noMealsToday: 'No meals logged today',
    searchFood: 'Search food...',
    customFood: 'Specify portion eaten (grams)',
    portionInfo: 'Reference serving size:',
  },
};

interface AppContextType {
  lang: Language;
  setLang: (l: Language) => void;
  t: (key: keyof typeof translations['th']) => string;
  foods: FoodItem[];
  meals: Meal[];
  dailyLog: DailyLog | null;
  quotas: NutrientQuota[];
  loading: boolean;
  refreshData: () => Promise<void>;
  logMeal: (food: FoodItem, quantityG: number, mealType: 'breakfast' | 'lunch' | 'dinner' | 'snack') => Promise<void>;
  logUrine: (amountMl: number) => Promise<void>;
}

const AppContext = createContext<AppContextType | undefined>(undefined);

export const AppProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { user } = useAuth();
  const [lang, setLangState] = useState<Language>('th');
  const [foods, setFoods] = useState<FoodItem[]>([]);
  const [meals, setMeals] = useState<Meal[]>([]);
  const [dailyLog, setDailyLog] = useState<DailyLog | null>(null);
  const [rules, setRules] = useState<any>(null);
  const [loading, setLoading] = useState(false);

  // Restore language preference
  useEffect(() => {
    const cachedLang = localStorage.getItem('lang') as Language;
    if (cachedLang) setLangState(cachedLang);
  }, []);

  const setLang = (l: Language) => {
    setLangState(l);
    localStorage.setItem('lang', l);
  };

  const t = (key: keyof typeof translations['th']): string => {
    return translations[lang][key] || translations['th'][key] || String(key);
  };

  // Load foods master data on mount
  useEffect(() => {
    async function loadFoods() {
      try {
        const res = await fetch('/food_master.json');
        const data = await res.json();
        
        // Map raw JSON fields to FoodItem interface
        const mappedFoods: FoodItem[] = data.map((j: any) => ({
          foodId: j['food_id'],
          name: j['ชื่ออาหาร'],
          searchKeywords: j['search_keywords'],
          category: j['ประเภท'],
          ingredients: j['วัตถุดิบทั้งหมด(ปริมาณด้วย) (g)'],
          servingSize: j['ปริมาณต่อจาน'],
          proteinG: parseFloat(j['โปรตีน(กรัม)']) || 0,
          potassiumMg: parseFloat(j['โพแทสเซียม(มิลลิกรัม)']) || 0,
          sodiumMg: parseFloat(j['โซเดียม(มิลลิกรัม)']) || 0,
          sugarG: parseFloat(j['นํ้าตาล(กรัม)']) || 0,
          carbG: parseFloat(j['คาโบไฮเดต(กรัม)']) || 0,
          waterMl: parseFloat(j['นํ้า(มิลลิลิตร)']) || 0,
          cookingMethod: j['วิธีปรุงอาหาร'],
          source: j['source'],
          sourceUrl: j['source_url'],
          notes: j['notes'],
        }));
        setFoods(mappedFoods);
      } catch (e) {
        console.error('Failed to load food master database:', e);
      }
    }
    loadFoods();
  }, []);

  // Sync / refresh data when user changes or manual refresh
  const refreshData = async () => {
    if (!user) {
      setMeals([]);
      setDailyLog(null);
      return;
    }
    setLoading(true);
    try {
      const todayStr = new Date().toISOString().split('T')[0];
      
      // Fetch today's meals
      const todayMeals = await mealRepo.getMealsForDate(todayStr);
      setMeals(todayMeals);

      // Fetch today's daily log
      const log = await mealRepo.getDailyLog(todayStr);
      setDailyLog(log);

      // Fetch rules for the user CKD stage
      if (user.ckdStage) {
        const { data: ruleData } = await supabase
          .from('ckd_rules')
          .select('*')
          .eq('stage', user.ckdStage)
          .maybeSingle();
        if (ruleData) setRules(ruleData);
      }
    } catch (e) {
      console.error('Failed to refresh today logs:', e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    refreshData();
  }, [user]);

  const logMeal = async (food: FoodItem, quantityG: number, mealType: 'breakfast' | 'lunch' | 'dinner' | 'snack') => {
    await mealRepo.logMeal(food, quantityG, mealType);
    await refreshData();
  };

  const logUrine = async (amountMl: number) => {
    await mealRepo.logUrine(amountMl);
    await refreshData();
  };

  // Compute quotas dynamically using the Domain logic
  const quotas = calculateQuotas(dailyLog, user?.weightKg || 60.0, rules);

  return (
    <AppContext.Provider
      value={{
        lang,
        setLang,
        t,
        foods,
        meals,
        dailyLog,
        quotas,
        loading,
        refreshData,
        logMeal,
        logUrine,
      }}
    >
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => {
  const context = useContext(AppContext);
  if (context === undefined) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
};
