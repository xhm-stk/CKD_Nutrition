import React, { useState } from 'react';
import { useApp } from '../contexts/AppContext';
import { X, HelpCircle } from 'lucide-react';
import confetti from 'canvas-confetti';

interface UrineEntrySheetProps {
  onClose: () => void;
}

export const UrineEntrySheet: React.FC<UrineEntrySheetProps> = ({ onClose }) => {
  const { t, logUrine } = useApp();
  const [customMl, setCustomMl] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (ml: number) => {
    if (ml <= 0) return;
    setIsLoading(true);
    try {
      await logUrine(ml);
      confetti({
        particleCount: 80,
        spread: 60,
        origin: { y: 0.8 },
      });
      onClose();
    } catch (e) {
      alert(t('saveError'));
    } finally {
      setIsLoading(false);
    }
  };

  const handleCustomSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const ml = parseInt(customMl);
    if (!isNaN(ml) && ml > 0) {
      handleSubmit(ml);
    }
  };

  return (
    <div className="overlay-backdrop" onClick={onClose}>
      <div className="bottom-sheet" onClick={(e) => e.stopPropagation()}>
        <div className="bottom-sheet-handle"></div>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '8px' }}>
          <h3 style={{ fontSize: '20px', fontWeight: 'bold' }}>{t('logUrine')}</h3>
          <button onClick={onClose} style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--color-muted)' }}>
            <X size={24} />
          </button>
        </div>

        {/* Quick Selection Buttons */}
        <div style={{ display: 'flex', gap: '12px', justifyContent: 'center', margin: '8px 0' }}>
          {[150, 300, 500].map((ml) => (
            <button
              key={ml}
              onClick={() => !isLoading && handleSubmit(ml)}
              disabled={isLoading}
              style={{
                flex: 1,
                padding: '12px 16px',
                borderRadius: '24px',
                backgroundColor: 'rgba(217, 119, 6, 0.06)',
                border: '1.5px solid rgba(217, 119, 6, 0.2)',
                color: '#d97706',
                fontWeight: '800',
                fontSize: '14px',
                cursor: 'pointer',
                transition: 'all 0.2s',
              }}
              onMouseOver={(e) => (e.currentTarget.style.backgroundColor = 'rgba(217, 119, 6, 0.12)')}
              onMouseOut={(e) => (e.currentTarget.style.backgroundColor = 'rgba(217, 119, 6, 0.06)')}
            >
              + {ml} ml
            </button>
          ))}
        </div>

        {/* Divider */}
        <div style={{ display: 'flex', alignItems: 'center', margin: '16px 0' }}>
          <div style={{ flex: 1, height: '1.5px', backgroundColor: 'var(--color-border)' }}></div>
          <span style={{ padding: '0 16px', fontSize: '14px', color: 'var(--color-muted)' }}>{t('customAdd')}</span>
          <div style={{ flex: 1, height: '1.5px', backgroundColor: 'var(--color-border)' }}></div>
        </div>

        {/* Custom Input */}
        <form onSubmit={handleCustomSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
          <div className="input-group">
            <span className="input-label">{t('enterAmount')} (ml)</span>
            <div className="input-wrapper">
              <HelpCircle className="input-icon" size={20} />
              <input
                type="number"
                placeholder="เช่น 300"
                value={customMl}
                onChange={(e) => setCustomMl(e.target.value)}
                className="premium-input"
                required
              />
            </div>
          </div>

          <button
            type="submit"
            className="premium-btn"
            disabled={isLoading}
            style={{
              backgroundColor: '#d97706',
              color: '#ffffff',
              opacity: isLoading ? 0.7 : 1,
              boxShadow: '0 4px 14px rgba(217, 119, 6, 0.2)',
            }}
          >
            {isLoading ? '...' : t('save')}
          </button>
        </form>
      </div>
    </div>
  );
};
