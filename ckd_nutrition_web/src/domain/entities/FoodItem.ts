export interface FoodItem {
  foodId: string;
  name: string;
  searchKeywords: string;
  category: string;
  ingredients: string;
  servingSize: string;
  proteinG: number;
  potassiumMg: number;
  sodiumMg: number;
  sugarG: number;
  carbG: number;
  waterMl: number;
  cookingMethod: string;
  source: string;
  sourceUrl?: string;
  notes?: string;
}
