import React, { useState } from 'react';
import { useApp } from '../contexts/AppContext';
import { X, Search, Utensils } from 'lucide-react';
import { FoodItem } from '../../domain/entities/FoodItem';
import confetti from 'canvas-confetti';

interface FoodEntrySheetProps {
  onClose: () => void;
}

export const FoodEntrySheet: React.FC<FoodEntrySheetProps> = ({ onClose }) => {
  const { t, foods, logMeal } = useApp();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedFood, setSelectedFood] = useState<FoodItem | null>(null);
  const [portionG, setPortionG] = useState('');
  const [mealType, setMealType] = useState<'breakfast' | 'lunch' | 'dinner' | 'snack'>('lunch');
  const [isLoading, setIsLoading] = useState(false);

  // Search filter
  const filteredFoods = foods.filter((f) => {
    if (!searchQuery.trim()) return false;
    const query = searchQuery.toLowerCase();
    return (
      f.name.toLowerCase().includes(query) ||
      f.searchKeywords.toLowerCase().includes(query) ||
      f.category.toLowerCase().includes(query)
    );
  }).slice(0, 5); // Limit to top 5 results

  const handleSelectFood = (food: FoodItem) => {
    setSelectedFood(food);
    // Parse default portion weight (e.g. "440g" -> 440)
    let defaultG = '100';
    if (food.servingSize) {
      const match = food.servingSize.match(/(\d+)/);
      if (match) defaultG = match[1];
    }
    setPortionG(defaultG);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedFood) return;
    const qty = parseFloat(portionG);
    if (isNaN(qty) || qty <= 0) return;

    setIsLoading(true);
    try {
      await logMeal(selectedFood, qty, mealType);
      confetti({
        particleCount: 100,
        spread: 70,
        origin: { y: 0.8 },
      });
      onClose();
    } catch (e) {
      alert(t('saveError'));
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="overlay-backdrop" onClick={onClose}>
      <div className="bottom-sheet" onClick={(e) => e.stopPropagation()}>
        <div className="bottom-sheet-handle"></div>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '8px' }}>
          <h3 style={{ fontSize: '20px', fontWeight: 'bold' }}>{t('logFood')}</h3>
          <button onClick={onClose} style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--color-muted)' }}>
            <X size={24} />
          </button>
        </div>

        {!selectedFood ? (
          <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
            {/* Search Input */}
            <div className="input-wrapper">
              <Search className="input-icon" size={20} />
              <input
                type="text"
                placeholder={t('searchFood')}
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="premium-input"
                autoFocus
              />
            </div>

            {/* Results List */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', maxHeight: '300px', overflowY: 'auto' }}>
              {filteredFoods.map((food) => (
                <div
                  key={food.foodId}
                  onClick={() => handleSelectFood(food)}
                  style={{
                    padding: '16px',
                    borderRadius: '16px',
                    border: '1.5px solid var(--color-border)',
                    cursor: 'pointer',
                    display: 'flex',
                    flexDirection: 'column',
                    gap: '4px',
                    textAlign: 'left',
                    transition: 'all 0.2s',
                  }}
                  onMouseOver={(e) => (e.currentTarget.style.borderColor = 'var(--color-primary)')}
                  onMouseOut={(e) => (e.currentTarget.style.borderColor = 'var(--color-border)')}
                >
                  <span style={{ fontWeight: 'bold', fontSize: '15px' }}>{food.name}</span>
                  <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap', fontSize: '12px' }}>
                    <span style={{ color: 'var(--color-success)', fontWeight: '600' }}>โปรตีน {food.proteinG}g</span>
                    <span style={{ color: 'var(--color-warning)', fontWeight: '600' }}>โซเดียม {food.sodiumMg}mg</span>
                    <span style={{ color: 'var(--color-error)', fontWeight: '600' }}>โพแทสเซียม {food.potassiumMg}mg</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        ) : (
          /* Food Log Configuration Form */
          <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
            <div
              style={{
                padding: '16px',
                borderRadius: '16px',
                backgroundColor: 'var(--color-accent-light)',
                border: '1.5px solid rgba(2, 132, 199, 0.1)',
                display: 'flex',
                alignItems: 'center',
                gap: '12px',
                textAlign: 'left',
              }}
            >
              <div
                style={{
                  width: '40px',
                  height: '40px',
                  borderRadius: '12px',
                  backgroundColor: '#e0f2fe',
                  color: 'var(--color-primary)',
                  display: 'flex',
                  justifyContent: 'center',
                  alignItems: 'center',
                }}
              >
                <Utensils size={20} />
              </div>
              <div style={{ display: 'flex', flexDirection: 'column' }}>
                <span style={{ fontWeight: 'bold', fontSize: '16px' }}>{selectedFood.name}</span>
                <span style={{ fontSize: '12px', color: 'var(--color-muted)' }}>
                  {t('portionInfo')} {selectedFood.servingSize || '100g'}
                </span>
              </div>
            </div>

            {/* Portion input */}
            <div className="input-group">
              <span className="input-label">{t('customFood')}</span>
              <input
                type="number"
                value={portionG}
                onChange={(e) => setPortionG(e.target.value)}
                className="premium-input"
                style={{ paddingLeft: '16px' }}
                required
              />
            </div>

            {/* Meal type selection */}
            <div className="input-group">
              <span className="input-label">{t('mealType')}</span>
              <select
                value={mealType}
                onChange={(e) => setMealType(e.target.value as any)}
                className="premium-input"
                style={{ paddingLeft: '16px', appearance: 'none', background: 'white' }}
              >
                <option value="breakfast">{t('breakfast')}</option>
                <option value="lunch">{t('lunch')}</option>
                <option value="dinner">{t('dinner')}</option>
                <option value="snack">{t('snack')}</option>
              </select>
            </div>

            {/* Action Buttons */}
            <div style={{ display: 'flex', gap: '12px' }}>
              <button
                type="button"
                className="premium-btn premium-btn-secondary"
                onClick={() => setSelectedFood(null)}
                style={{ flex: 1 }}
              >
                ย้อนกลับ
              </button>
              <button
                type="submit"
                className="premium-btn premium-btn-primary"
                disabled={isLoading}
                style={{ flex: 2, opacity: isLoading ? 0.7 : 1 }}
              >
                {isLoading ? '...' : t('save')}
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
};
