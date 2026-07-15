import { IAuthRepository } from '../../domain/repositories/IAuthRepository';
import { UserProfile } from '../../domain/entities/User';
import { supabase } from '../datasources/SupabaseClient';

export class AuthRepository implements IAuthRepository {
  async signUp(
    email: string,
    password: string,
    name: string,
    nationalId: string,
    pdpaConsent: boolean
  ): Promise<UserProfile> {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          name,
          national_id: nationalId,
          pdpa_consent: pdpaConsent,
        },
      },
    });

    if (error) throw new Error(error.message);
    if (!data.user) throw new Error('Registration failed');

    const profile: UserProfile = {
      userId: data.user.id,
      email: data.user.email || email,
      name: name,
      nationalId: nationalId,
      pdpaConsentedAt: pdpaConsent ? new Date().toISOString() : undefined,
    };

    // Try updating public.profiles table (robust fallback)
    try {
      await supabase
        .from('profiles')
        .update({
          name: name,
          national_id: nationalId,
          pdpa_consented_at: pdpaConsent ? new Date().toISOString() : null,
        })
        .eq('id', data.user.id);
    } catch (err) {
      console.warn('Optional profiles update warning:', err);
    }

    return profile;
  }

  async signIn(email: string, password: string): Promise<UserProfile> {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) throw new Error(error.message);
    if (!data.user) throw new Error('Login failed');

    // Fetch details from profiles and user_health_profiles
    const profile: UserProfile = {
      userId: data.user.id,
      email: data.user.email || email,
    };

    try {
      const { data: profData } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', data.user.id)
        .maybeSingle();

      if (profData) {
        profile.name = profData.name;
        profile.nationalId = profData.national_id;
        profile.pdpaConsentedAt = profData.pdpa_consented_at;
      }
    } catch (e) {
      console.warn('Failed to fetch public profile details:', e);
    }

    try {
      const { data: healthData } = await supabase
        .from('user_health_profiles')
        .select('*')
        .eq('user_id', data.user.id)
        .maybeSingle();

      if (healthData) {
        profile.weightKg = healthData.weight_kg;
        profile.heightCm = healthData.height_cm;
        profile.gender = healthData.gender;
        profile.ckdStage = healthData.ckd_stage;
      }
    } catch (e) {
      console.warn('Failed to fetch health profile details:', e);
    }

    return profile;
  }

  async signOut(): Promise<void> {
    const { error } = await supabase.auth.signOut();
    if (error) throw new Error(error.message);
  }

  async getCurrentUser(): Promise<UserProfile | null> {
    const { data: { session }, error } = await supabase.auth.getSession();
    if (error || !session || !session.user) return null;

    const user = session.user;
    const profile: UserProfile = {
      userId: user.id,
      email: user.email || '',
    };

    try {
      const { data: profData } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.id)
        .maybeSingle();

      if (profData) {
        profile.name = profData.name;
        profile.nationalId = profData.national_id;
        profile.pdpaConsentedAt = profData.pdpa_consented_at;
      }
    } catch (e) {
      console.warn('Failed to fetch profile details on init:', e);
    }

    try {
      const { data: healthData } = await supabase
        .from('user_health_profiles')
        .select('*')
        .eq('user_id', user.id)
        .maybeSingle();

      if (healthData) {
        profile.weightKg = healthData.weight_kg;
        profile.heightCm = healthData.height_cm;
        profile.gender = healthData.gender;
        profile.ckdStage = healthData.ckd_stage;
      }
    } catch (e) {
      console.warn('Failed to fetch health details on init:', e);
    }

    return profile;
  }

  async saveHealthProfile(
    weightKg: number,
    heightCm: number,
    gender: 'male' | 'female',
    ckdStage: string
  ): Promise<UserProfile> {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) throw new Error('No authenticated user');

    const { error } = await supabase.from('user_health_profiles').upsert(
      {
        user_id: user.id,
        weight_kg: weightKg,
        height_cm: heightCm,
        gender,
        ckd_stage: ckdStage,
      },
      { onConflict: 'user_id' }
    );

    if (error) throw new Error(error.message);

    // Return updated user profile structure
    const updatedUser = await this.getCurrentUser();
    if (!updatedUser) throw new Error('Failed to retrieve updated profile');
    return updatedUser;
  }

  async deleteAccount(): Promise<void> {
    // Call the delete_user_account RPC function
    const { error } = await supabase.rpc('delete_user_account');
    if (error) throw new Error(error.message);
    await this.signOut();
  }
}
