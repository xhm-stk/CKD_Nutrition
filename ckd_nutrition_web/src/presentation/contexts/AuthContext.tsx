import React, { createContext, useContext, useState, useEffect } from 'react';
import { UserProfile } from '../../domain/entities/User';
import { AuthRepository } from '../../data/repositories/AuthRepository';

const authRepo = new AuthRepository();

interface AuthContextType {
  user: UserProfile | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signUp: (
    email: string,
    password: string,
    name: string,
    nationalId: string,
    pdpaConsent: boolean
  ) => Promise<void>;
  signOut: () => Promise<void>;
  saveHealthProfile: (
    weightKg: number,
    heightCm: number,
    gender: 'male' | 'female',
    ckdStage: string
  ) => Promise<void>;
  deleteAccount: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<UserProfile | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function initUser() {
      try {
        const u = await authRepo.getCurrentUser();
        setUser(u);
      } catch (e) {
        console.error('Failed to restore session:', e);
      } finally {
        setLoading(false);
      }
    }
    initUser();
  }, []);

  const signIn = async (email: string, password: string) => {
    setLoading(true);
    try {
      const u = await authRepo.signIn(email, password);
      setUser(u);
    } finally {
      setLoading(false);
    }
  };

  const signUp = async (
    email: string,
    password: string,
    name: string,
    nationalId: string,
    pdpaConsent: boolean
  ) => {
    setLoading(true);
    try {
      const u = await authRepo.signUp(email, password, name, nationalId, pdpaConsent);
      setUser(u);
    } finally {
      setLoading(false);
    }
  };

  const signOut = async () => {
    setLoading(true);
    try {
      await authRepo.signOut();
      setUser(null);
    } finally {
      setLoading(false);
    }
  };

  const saveHealthProfile = async (
    weightKg: number,
    heightCm: number,
    gender: 'male' | 'female',
    ckdStage: string
  ) => {
    setLoading(true);
    try {
      const u = await authRepo.saveHealthProfile(weightKg, heightCm, gender, ckdStage);
      setUser(u);
    } finally {
      setLoading(false);
    }
  };

  const deleteAccount = async () => {
    setLoading(true);
    try {
      await authRepo.deleteAccount();
      setUser(null);
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        loading,
        signIn,
        signUp,
        signOut,
        saveHealthProfile,
        deleteAccount,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
