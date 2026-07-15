import React, { useState } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { useApp } from '../contexts/AppContext';
import { Mail, Lock, User, CreditCard } from 'lucide-react';

export const Login: React.FC = () => {
  const { signIn, signUp } = useAuth();
  const { t } = useApp();
  const [isRegisterMode, setIsRegisterMode] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [name, setName] = useState('');
  const [nationalId, setNationalId] = useState('');
  const [pdpaConsent, setPdpaConsent] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  // Thai National ID Checksum Validation
  const validateThaiNationalId = (id: string): boolean => {
    const cleanId = id.trim().replace(/\D/g, '');
    if (cleanId.length !== 13) return false;
    let sum = 0;
    for (let i = 0; i < 12; i++) {
      sum += parseInt(cleanId.charAt(i)) * (13 - i);
    }
    const check = (11 - (sum % 11)) % 10;
    return check === parseInt(cleanId.charAt(12));
  };

  const validatePasswordStrength = (pass: string): boolean => {
    // Requires at least 8 chars, 1 uppercase, 1 number
    if (pass.length < 8) return false;
    if (!/[A-Z]/.test(pass)) return false;
    if (!/[0-9]/.test(pass)) return false;
    return true;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setIsLoading(true);

    try {
      if (isRegisterMode) {
        // Registration Validations
        if (!name.trim()) {
          setError(t('enterName'));
          setIsLoading(false);
          return;
        }
        if (!validateThaiNationalId(nationalId)) {
          setError(t('nationalIdError'));
          setIsLoading(false);
          return;
        }
        if (!validatePasswordStrength(password)) {
          setError(t('passwordStrengthError'));
          setIsLoading(false);
          return;
        }
        if (password !== confirmPassword) {
          setError(t('confirmPasswordError'));
          setIsLoading(false);
          return;
        }
        if (!pdpaConsent) {
          setError(t('pdpaError'));
          setIsLoading(false);
          return;
        }

        await signUp(email, password, name, nationalId, pdpaConsent);
      } else {
        // Sign In
        await signIn(email, password);
      }
    } catch (err: any) {
      setError(err.message || 'Authentication failed');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div
      style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        minHeight: '100vh',
        padding: '24px',
        background: 'linear-gradient(135deg, #f0f7ff 0%, #e0f2fe 100%)',
      }}
    >
      <div
        className="progress-card"
        style={{
          width: '100%',
          maxWidth: '400px',
          padding: '32px 24px',
          borderRadius: '24px',
          backgroundColor: '#ffffff',
          boxShadow: 'var(--shadow-lg)',
          textAlign: 'center',
        }}
      >
        {/* App Title */}
        <h2 style={{ fontSize: '28px', color: 'var(--color-primary)', marginBottom: '8px' }}>
          {t('appName')}
        </h2>
        <p style={{ color: 'var(--color-muted)', fontSize: '14px', marginBottom: '24px' }}>
          {isRegisterMode ? 'สร้างบัญชีเพื่อเข้าดูแลโภชนาการของคุณ' : 'กรุณาเข้าสู่ระบบเพื่อใช้งานระบบควบคุมและประเมินภาวะโรคไต'}
        </p>

        {/* Error Banner */}
        {error && (
          <div
            className="alert-card alert-card-error"
            style={{ marginBottom: '20px', textAlign: 'left' }}
          >
            <div className="alert-text-container">
              <span className="alert-title">เกิดข้อผิดพลาด</span>
              <span className="alert-desc">{error}</span>
            </div>
          </div>
        )}

        {/* Form */}
        <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
          {isRegisterMode && (
            <>
              {/* Full Name */}
              <div className="input-group">
                <span className="input-label">{t('name')}</span>
                <div className="input-wrapper">
                  <User className="input-icon" size={20} />
                  <input
                    type="text"
                    placeholder="เช่น สมชาย ใจดี"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    className="premium-input"
                    required
                  />
                </div>
              </div>

              {/* National ID */}
              <div className="input-group">
                <span className="input-label">{t('nationalId')}</span>
                <div className="input-wrapper">
                  <CreditCard className="input-icon" size={20} />
                  <input
                    type="text"
                    maxLength={13}
                    placeholder="เลขบัตรประชาชน 13 หลัก"
                    value={nationalId}
                    onChange={(e) => setNationalId(e.target.value.replace(/\D/g, ''))}
                    className="premium-input"
                    required
                  />
                </div>
              </div>
            </>
          )}

          {/* Email */}
          <div className="input-group">
            <span className="input-label">{t('email')}</span>
            <div className="input-wrapper">
              <Mail className="input-icon" size={20} />
              <input
                type="email"
                placeholder="example@email.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="premium-input"
                required
              />
            </div>
          </div>

          {/* Password */}
          <div className="input-group">
            <span className="input-label">{t('password')}</span>
            <div className="input-wrapper">
              <Lock className="input-icon" size={20} />
              <input
                type="password"
                placeholder="รหัสผ่านเชื่อมต่อ"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="premium-input"
                required
              />
            </div>
          </div>

          {isRegisterMode && (
            /* Confirm Password */
            <div className="input-group">
              <span className="input-label">{t('confirmPassword')}</span>
              <div className="input-wrapper">
                <Lock className="input-icon" size={20} />
                <input
                  type="password"
                  placeholder="ยืนยันรหัสผ่านอีกครั้ง"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  className="premium-input"
                  required
                />
              </div>
            </div>
          )}

          {isRegisterMode && (
            /* PDPA Consent Checkbox */
            <div
              style={{
                display: 'flex',
                gap: '10px',
                alignItems: 'flex-start',
                textAlign: 'left',
                marginTop: '8px',
              }}
            >
              <input
                type="checkbox"
                id="pdpa"
                checked={pdpaConsent}
                onChange={(e) => setPdpaConsent(e.target.checked)}
                style={{ marginTop: '4px', cursor: 'pointer' }}
              />
              <label
                htmlFor="pdpa"
                style={{ fontSize: '13px', color: 'var(--color-muted)', cursor: 'pointer' }}
              >
                {t('acceptPDPA')}
              </label>
            </div>
          )}

          <button
            type="submit"
            className="premium-btn premium-btn-primary"
            style={{ marginTop: '12px', opacity: isLoading ? 0.7 : 1 }}
            disabled={isLoading}
          >
            {isLoading ? '...' : isRegisterMode ? t('register') : t('login')}
          </button>
        </form>

        {/* Toggle Mode */}
        <p style={{ marginTop: '24px', fontSize: '14px', color: 'var(--color-muted)' }}>
          {isRegisterMode ? 'มีบัญชีผู้ใช้อยู่แล้ว?' : 'ยังไม่มีบัญชีผู้ใช้?'}
          <span
            onClick={() => {
              setIsRegisterMode(!isRegisterMode);
              setError(null);
            }}
            style={{
              color: 'var(--color-primary)',
              fontWeight: 'bold',
              marginLeft: '8px',
              cursor: 'pointer',
            }}
          >
            {isRegisterMode ? t('login') : t('register')}
          </span>
        </p>
      </div>
    </div>
  );
};
