import { IMealRepository } from '../../domain/repositories/IMealRepository';
import { Meal } from '../../domain/entities/Meal';
import { DailyLog } from '../../domain/entities/DailyLog';
import { FoodItem } from '../../domain/entities/FoodItem';
import { supabase } from '../datasources/SupabaseClient';

export class MealRepository implements IMealRepository {
  async logMeal(
    food: FoodItem,
    quantityG: number,
    mealType: 'breakfast' | 'lunch' | 'dinner' | 'snack',
    eatenAt?: Date
  ): Promise<void> {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) throw new Error('No authenticated user');

    // Parse portion size
    let divisor = 100.0;
    const sizeStr = food.servingSize || '';
    if (sizeStr) {
      const match = sizeStr.toLowerCase().match(/(\d+)\s*g/);
      if (match) {
        const weight = parseFloat(match[1]);
        if (weight > 0) {
          divisor = weight;
        }
      }
    }

    const ratio = quantityG / divisor;

    const protein = food.proteinG * ratio;
    const potassium = food.potassiumMg * ratio;
    const sodium = food.sodiumMg * ratio;
    const sugar = food.sugarG * ratio;
    const carb = food.carbG * ratio;

    // Only count water if it is a pure water beverage
    const isWaterBeverage =
      food.foodId === 'quick_water' ||
      food.name.includes('น้ำดื่ม') ||
      food.name.includes('น้ำแร่') ||
      food.name.includes('น้ำเปล่า') ||
      food.name.includes('น้ำสะอาด');
    const water = isWaterBeverage ? food.waterMl * ratio : 0.0;

    // Call Supabase RPC
    const { error } = await supabase.rpc('log_meal', {
      p_food_id: food.foodId,
      p_food_name: food.name,
      p_quantity_g: quantityG,
      p_meal_type: mealType,
      p_protein: protein,
      p_potassium: potassium,
      p_sodium: sodium,
      p_sugar: sugar,
      p_carb: carb,
      p_water: water,
    });

    if (error) throw new Error(error.message);
  }

  async logUrine(amountMl: number, loggedAt?: Date): Promise<void> {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) throw new Error('No authenticated user');

    const timestamp = (loggedAt || new Date()).toISOString();

    const { error } = await supabase.from('urine_logs').insert({
      user_id: user.id,
      amount_ml: amountMl,
      logged_at: timestamp,
    });

    if (error) throw new Error(error.message);
  }

  async getDailyLog(dateStr: string): Promise<DailyLog | null> {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return null;

    const { data, error } = await supabase
      .from('daily_logs')
      .select('*')
      .eq('user_id', user.id)
      .eq('log_date', dateStr)
      .maybeSingle();

    if (error) throw new Error(error.message);
    if (!data) return null;

    return {
      id: data.id,
      userId: data.user_id,
      logDate: data.log_date,
      totalProteinG: data.total_protein_g,
      totalPotassiumMg: data.total_potassium_mg,
      totalSodiumMg: data.total_sodium_mg,
      totalSugarG: data.total_sugar_g,
      totalCarbG: data.total_carb_g,
      totalWaterMl: data.total_water_ml,
      totalUrineMl: data.total_urine_ml || 0,
      createdAt: data.created_at,
      updatedAt: data.updated_at,
    };
  }

  async getTodayMeals(): Promise<Meal[]> {
    const todayStr = new Date().toISOString().split('T')[0];
    return this.getMealsForDate(todayStr);
  }

  async getMealsForDate(dateStr: string): Promise<Meal[]> {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return [];

    // Filter meals by log date using postgrest filters
    // A meal's eaten_at is timestamptz. We want to query where eaten_at is on dateStr (e.g. 2026-07-12)
    const { data, error } = await supabase
      .from('meals')
      .select('*')
      .eq('user_id', user.id)
      .gte('eaten_at', `${dateStr}T00:00:00.000Z`)
      .lte('eaten_at', `${dateStr}T23:59:59.999Z`)
      .order('eaten_at', { ascending: true });

    if (error) throw new Error(error.message);
    if (!data) return [];

    return data.map((m) => ({
      id: m.id,
      userId: m.user_id,
      foodId: m.food_id,
      foodName: m.food_name,
      quantityG: m.quantity_g,
      mealType: m.meal_type,
      proteinG: m.protein_g,
      potassiumMg: m.potassium_mg,
      sodiumMg: m.sodium_mg,
      sugarG: m.sugar_g,
      carbG: m.carb_g,
      waterMl: m.water_ml,
      eatenAt: m.eaten_at,
    }));
  }

  async getUrineLogsForDate(dateStr: string): Promise<number> {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return 0;

    const { data, error } = await supabase
      .from('urine_logs')
      .select('amount_ml')
      .eq('user_id', user.id)
      .gte('logged_at', `${dateStr}T00:00:00.000Z`)
      .lte('logged_at', `${dateStr}T23:59:59.999Z`);

    if (error) throw new Error(error.message);
    if (!data) return 0;

    return data.reduce((sum, log) => sum + (log.amount_ml || 0), 0);
  }

  async getHistoryLogs(): Promise<{ dateStr: string; totalProteinG: number; limitProteinG: number }[]> {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return [];

    const { data, error } = await supabase
      .from('daily_logs')
      .select('log_date, total_protein_g')
      .eq('user_id', user.id)
      .order('log_date', { ascending: false })
      .limit(30);

    if (error) throw new Error(error.message);
    if (!data) return [];

    return data.map((d) => ({
      dateStr: d.log_date,
      totalProteinG: d.total_protein_g,
      limitProteinG: 0, // Will be computed in Domain logic using user CKD stage
    }));
  }
}
