import { Meal } from '../entities/Meal';
import { DailyLog } from '../entities/DailyLog';
import { FoodItem } from '../entities/FoodItem';

export interface IMealRepository {
  logMeal(food: FoodItem, quantityG: number, mealType: 'breakfast' | 'lunch' | 'dinner' | 'snack', eatenAt?: Date): Promise<void>;
  logUrine(amountMl: number, loggedAt?: Date): Promise<void>;
  getDailyLog(dateStr: string): Promise<DailyLog | null>;
  getTodayMeals(): Promise<Meal[]>;
  getMealsForDate(dateStr: string): Promise<Meal[]>;
  getUrineLogsForDate(dateStr: string): Promise<number>;
  getHistoryLogs(): Promise<{ dateStr: string; totalProteinG: number; limitProteinG: number }[]>;
}
