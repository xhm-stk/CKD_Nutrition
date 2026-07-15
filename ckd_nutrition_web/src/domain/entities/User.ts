export interface UserProfile {
  userId: string;
  email: string;
  name?: string;
  weightKg?: number;
  heightCm?: number;
  gender?: 'male' | 'female';
  ckdStage?: 'stage_1' | 'stage_2' | 'stage_3a' | 'stage_3b' | 'stage_4' | 'stage_5';
  nationalId?: string;
  pdpaConsentedAt?: string;
}
