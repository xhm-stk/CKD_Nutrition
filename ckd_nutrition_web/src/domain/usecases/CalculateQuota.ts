import { DailyLog } from '../entities/DailyLog';

export interface NutrientQuota {
  label: string;
  unit: string;
  consumed: number;
  limit: number;
}

export function calculateQuotas(
  log: DailyLog | null,
  weightKg: number,
  rules: {
    protein_multiplier: number;
    potassium_limit_mg: number;
    sodium_limit_mg: number;
    sugar_limit_g: number;
    carb_limit_g: number;
    water_limit_ml: number;
  } | null
): NutrientQuota[] {
  const weight = weightKg || 60.0;
  const multiplier = rules?.protein_multiplier ?? 0.8;

  const proteinLimit = weight * multiplier;
  const potassiumLimit = rules?.potassium_limit_mg ?? 2000.0;
  const sodiumLimit = rules?.sodium_limit_mg ?? 2000.0;
  const sugarLimit = rules?.sugar_limit_g ?? 24.0;
  const carbLimit = rules?.carb_limit_g ?? 150.0;
  const waterLimit = rules?.water_limit_ml ?? 1500.0;

  return [
    {
      label: 'protein',
      unit: 'g',
      consumed: log?.totalProteinG ?? 0,
      limit: proteinLimit,
    },
    {
      label: 'potassium',
      unit: 'mg',
      consumed: log?.totalPotassiumMg ?? 0,
      limit: potassiumLimit,
    },
    {
      label: 'sodium',
      unit: 'mg',
      consumed: log?.totalSodiumMg ?? 0,
      limit: sodiumLimit,
    },
    {
      label: 'sugar',
      unit: 'g',
      consumed: log?.totalSugarG ?? 0,
      limit: sugarLimit,
    },
    {
      label: 'carb',
      unit: 'g',
      consumed: log?.totalCarbG ?? 0,
      limit: carbLimit,
    },
    {
      label: 'water',
      unit: 'ml',
      consumed: log?.totalWaterMl ?? 0,
      limit: waterLimit,
    },
  ];
}
