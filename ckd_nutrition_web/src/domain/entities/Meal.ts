export interface Meal {
  id: string;
  userId: string;
  foodId: string;
  foodName: string;
  quantityG: number;
  mealType: 'breakfast' | 'lunch' | 'dinner' | 'snack';
  proteinG: number;
  potassiumMg: number;
  sodiumMg: number;
  sugarG: number;
  carbG: number;
  waterMl: number;
  eatenAt: string;
}
