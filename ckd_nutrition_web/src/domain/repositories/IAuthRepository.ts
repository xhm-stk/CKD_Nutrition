import { UserProfile } from '../entities/User';

export interface IAuthRepository {
  signUp(email: string, password: string, name: string, nationalId: string, pdpaConsent: boolean): Promise<UserProfile>;
  signIn(email: string, password: string): Promise<UserProfile>;
  signOut(): Promise<void>;
  getCurrentUser(): Promise<UserProfile | null>;
  saveHealthProfile(weightKg: number, heightCm: number, gender: 'male' | 'female', ckdStage: string): Promise<UserProfile>;
  deleteAccount(): Promise<void>;
}
