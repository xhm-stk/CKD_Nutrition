import React, { useState } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { useApp } from '../contexts/AppContext';
import { Ruler, Activity, HelpCircle } from 'lucide-react';

export const HealthSetup: React.FC = () => {
  const { user, saveHealthProfile } = useAuth();
  const { t } = useApp();
  const [weight, setWeight] = useState(user?.weightKg ? String(user.weightKg) : '');
  const [height, setHeight] = useState(user?.heightCm ? String(user.heightCm) : '');
  const [gender, setGender] = useState<'male' | 'female'>(user?.gender || 'male');
  const [ckdStage, setCkdStage] = useState(user?.ckdStage || 'stage_3a');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    const w = parseFloat(weight);
    const h = parseFloat(height);

    if (isNaN(w) || w < 20 || w > 300) {
      setError('กรุณาระบุน้ำหนักที่ถูกต้อง (20 - 300 กิโลกรัม)');
      return;
    }
    if (isNaN(h) || h < 100 || h > 250) {
      setError('กรุณาระบุส่วนสูงที่ถูกต้อง (100 - 250 เซนติเมตร)');
      return;
    }

    setIsLoading(true);
    try {
      await saveHealthProfile(w, h, gender, ckdStage);
    } catch (err: any) {
      setError(err.message || 'Failed to save health profile');
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
          textAlign: 'left',
        }}
      >
        <h2 style={{ fontSize: '24px', color: 'var(--color-primary)', marginBottom: '8px', textAlign: 'center' }}>
          ข้อมูลสุขภาพเริ่มต้น
        </h2>
        <p style={{ color: 'var(--color-muted)', fontSize: '13px', marginBottom: '24px', textAlign: 'center' }}>
          กรุณากรอกข้อมูลจริงเพื่อใช้คำนวณโควต้าโปรตีน โซเดียม โพแทสเซียม ของผู้ป่วยโรคไตได้อย่างถูกต้องปลอดภัย
        </p>

        {error && (
          <div className="alert-card alert-card-error" style={{ marginBottom: '20px' }}>
            <div className="alert-text-container">
              <span className="alert-title">แจ้งเตือน</span>
              <span className="alert-desc">{error}</span>
            </div>
          </div>
        )}

        <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
          {/* Weight */}
          <div className="input-group">
            <span className="input-label">{t('weight')}</span>
            <div className="input-wrapper">
              <Activity className="input-icon" size={20} />
              <input
                type="number"
                step="any"
                placeholder="เช่น 65.5"
                value={weight}
                onChange={(e) => setWeight(e.target.value)}
                className="premium-input"
                required
              />
            </div>
          </div>

          {/* Height */}
          <div className="input-group">
            <span className="input-label">{t('height')}</span>
            <div className="input-wrapper">
              <Ruler className="input-icon" size={20} />
              <input
                type="number"
                step="any"
                placeholder="เช่น 170"
                value={height}
                onChange={(e) => setHeight(e.target.value)}
                className="premium-input"
                required
              />
            </div>
          </div>

          {/* Gender */}
          <div className="input-group">
            <span className="input-label">{t('gender')}</span>
            <div style={{ display: 'flex', gap: '12px' }}>
              <button
                type="button"
                onClick={() => setGender('male')}
                style={{
                  flex: 1,
                  padding: '12px',
                  borderRadius: '16px',
                  border: gender === 'male' ? '2px solid var(--color-primary)' : '1.5px solid var(--color-border)',
                  backgroundColor: gender === 'male' ? 'var(--color-primary-light)' : 'transparent',
                  color: gender === 'male' ? 'var(--color-primary)' : 'var(--color-muted)',
                  fontWeight: 'bold',
                  cursor: 'pointer',
                }}
              >
                {t('male')}
              </button>
              <button
                type="button"
                onClick={() => setGender('female')}
                style={{
                  flex: 1,
                  padding: '12px',
                  borderRadius: '16px',
                  border: gender === 'female' ? '2px solid var(--color-primary)' : '1.5px solid var(--color-border)',
                  backgroundColor: gender === 'female' ? 'var(--color-primary-light)' : 'transparent',
                  color: gender === 'female' ? 'var(--color-primary)' : 'var(--color-muted)',
                  fontWeight: 'bold',
                  cursor: 'pointer',
                }}
              >
                {t('female')}
              </button>
            </div>
          </div>

          {/* CKD Stage */}
          <div className="input-group">
            <span className="input-label">{t('ckdStage')}</span>
            <div className="input-wrapper">
              <HelpCircle className="input-icon" size={20} />
              <select
                value={ckdStage}
                onChange={(e) => setCkdStage(e.target.value as any)}
                className="premium-input"
                style={{ appearance: 'none', background: 'white' }}
              >
                <option value="stage_1">ไตระยะที่ 1 (eGFR &gt;= 90)</option>
                <option value="stage_2">ไตระยะที่ 2 (eGFR 60 - 89)</option>
                <option value="stage_3a">ไตระยะที่ 3a (eGFR 45 - 59)</option>
                <option value="stage_3b">ไตระยะที่ 3b (eGFR 30 - 44)</option>
                <option value="stage_4">ไตระยะที่ 4 (eGFR 15 - 29)</option>
                <option value="stage_5">ไตระยะที่ 5 (eGFR &lt; 15)</option>
              </select>
            </div>
          </div>

          <button
            type="submit"
            className="premium-btn premium-btn-primary"
            style={{ marginTop: '12px', opacity: isLoading ? 0.7 : 1 }}
            disabled={isLoading}
          >
            {isLoading ? '...' : t('save')}
          </button>
        </form>
      </div>
    </div>
  );
};
