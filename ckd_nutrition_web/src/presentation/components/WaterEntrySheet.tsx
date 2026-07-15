import React, { useState } from 'react';
import { useApp } from '../contexts/AppContext';
import { X, Droplets } from 'lucide-react';
import confetti from 'canvas-confetti';

interface WaterEntrySheetProps {
  onClose: () => void;
}

export const WaterEntrySheet: React.FC<WaterEntrySheetProps> = ({ onClose }) => {
  const { t, logMeal } = useApp();
  const [customMl, setCustomMl] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (ml: number) => {
    if (ml <= 0) return;
    setIsLoading(true);
    try {
      // Mocking water as quick_water FoodItem
      const waterFood = {
        foodId: 'quick_water',
        name: t('water'),
        searchKeywords: 'น้ำ,น้ำดื่ม,water',
        category: 'เครื่องดื่ม',
        ingredients: 'น้ำเปล่า 100%',
        servingSize: '100g',
        proteinG: 0,
        potassiumMg: 0,
        sodiumMg: 0,
        sugarG: 0,
        carbG: 0,
        waterMl: 100.0, // 100ml per 100g
        cookingMethod: '',
        source: '',
      };

      await logMeal(waterFood, ml, 'snack');
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
          <h3 style={{ fontSize: '20px', fontWeight: 'bold' }}>{t('logWater')}</h3>
          <button onClick={onClose} style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--color-muted)' }}>
            <X size={24} />
          </button>
        </div>

        {/* Quick Selection Buttons */}
        <div style={{ display: 'flex', gap: '12px', justifyContent: 'center', margin: '8px 0' }}>
          {[100, 250, 500].map((ml) => (
            <button
              key={ml}
              onClick={() => !isLoading && handleSubmit(ml)}
              disabled={isLoading}
              style={{
                flex: 1,
                padding: '12px 16px',
                borderRadius: '24px',
                backgroundColor: 'rgba(2, 132, 199, 0.06)',
                border: '1.5px solid rgba(2, 132, 199, 0.2)',
                color: 'var(--color-primary)',
                fontWeight: '800',
                fontSize: '14px',
                cursor: 'pointer',
                transition: 'all 0.2s',
              }}
              onMouseOver={(e) => (e.currentTarget.style.backgroundColor = 'rgba(2, 132, 199, 0.12)')}
              onMouseOut={(e) => (e.currentTarget.style.backgroundColor = 'rgba(2, 132, 199, 0.06)')}
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
              <Droplets className="input-icon" size={20} />
              <input
                type="number"
                placeholder="เช่น 150"
                value={customMl}
                onChange={(e) => setCustomMl(e.target.value)}
                className="premium-input"
                required
              />
            </div>
          </div>

          <button
            type="submit"
            className="premium-btn premium-btn-primary"
            disabled={isLoading}
            style={{ opacity: isLoading ? 0.7 : 1 }}
          >
            {isLoading ? '...' : t('save')}
          </button>
        </form>
      </div>
    </div>
  );
};
