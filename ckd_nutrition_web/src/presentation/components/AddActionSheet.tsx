import React from 'react';
import { useApp } from '../contexts/AppContext';
import { X, Plus, Droplets, HelpCircle, UtensilsCrossed } from 'lucide-react';

interface AddActionSheetProps {
  onClose: () => void;
  onOpenWater: () => void;
  onOpenUrine: () => void;
  onOpenLogFood: () => void;
}

export const AddActionSheet: React.FC<AddActionSheetProps> = ({
  onClose,
  onOpenWater,
  onOpenUrine,
  onOpenLogFood,
}) => {
  const { t } = useApp();

  return (
    <div className="overlay-backdrop" onClick={onClose}>
      <div className="bottom-sheet" onClick={(e) => e.stopPropagation()}>
        <div className="bottom-sheet-handle"></div>
        <div className="flex justify-between items-center mb-2" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <h3 className="text-xl font-bold" style={{ fontSize: '20px', fontWeight: 'bold' }}>
            {t('appName')}
          </h3>
          <button onClick={onClose} style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--color-muted)' }}>
            <X size={24} />
          </button>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
          {/* Log Food */}
          <div className="action-item-card" onClick={onOpenLogFood}>
            <div className="action-icon-circle" style={{ backgroundColor: '#e0f2fe', color: '#0284c7' }}>
              <Plus size={24} />
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '2px', flex: 1, textAlign: 'left' }}>
              <span style={{ fontWeight: 'bold', fontSize: '15px' }}>{t('logFood')}</span>
              <span style={{ fontSize: '12px', color: 'var(--color-muted)' }}>เพิ่มอาหารจานหลัก มื้อเช้า กลางวัน หรือมื้อเย็น</span>
            </div>
          </div>

          {/* Log Water */}
          <div className="action-item-card" onClick={onOpenWater}>
            <div className="action-icon-circle" style={{ backgroundColor: '#ecfeff', color: '#0891b2' }}>
              <Droplets size={24} />
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '2px', flex: 1, textAlign: 'left' }}>
              <span style={{ fontWeight: 'bold', fontSize: '15px' }}>{t('logWater')}</span>
              <span style={{ fontSize: '12px', color: 'var(--color-muted)' }}>บันทึกปริมาณน้ำดื่มสะสมของวัน</span>
            </div>
          </div>

          {/* Log Urine */}
          <div className="action-item-card" onClick={onOpenUrine}>
            <div className="action-icon-circle" style={{ backgroundColor: '#fffbeb', color: '#d97706' }}>
              <HelpCircle size={24} />
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '2px', flex: 1, textAlign: 'left' }}>
              <span style={{ fontWeight: 'bold', fontSize: '15px' }}>{t('logUrine')}</span>
              <span style={{ fontSize: '12px', color: 'var(--color-muted)' }}>บันทึกปริมาณน้ำออกจากร่างกายเพื่อหาสมดุลน้ำ</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
