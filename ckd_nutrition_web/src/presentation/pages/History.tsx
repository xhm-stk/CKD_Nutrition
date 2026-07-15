import React, { useState, useEffect } from 'react';
import { useApp } from '../contexts/AppContext';
import { useAuth } from '../contexts/AuthContext';
import { supabase } from '../../data/datasources/SupabaseClient';
import { Meal } from '../../domain/entities/Meal';
import { Calendar, Eye, X } from 'lucide-react';

export const History: React.FC = () => {
  const { t } = useApp();
  const { user } = useAuth();
  const [historyItems, setHistoryItems] = useState<any[]>([]);
  const [selectedDate, setSelectedDate] = useState<string | null>(null);
  const [selectedMeals, setSelectedMeals] = useState<Meal[]>([]);
  const [isLoading, setIsLoading] = useState(false);

  // Fetch 30 day history
  const loadHistory = async () => {
    if (!user) return;
    setIsLoading(true);
    try {
      const { data, error } = await supabase
        .from('daily_logs')
        .select('*')
        .eq('user_id', user.userId)
        .order('log_date', { ascending: false })
        .limit(30);

      if (error) throw new Error(error.message);
      setHistoryItems(data || []);
    } catch (e) {
      console.error('Failed to load history logs:', e);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadHistory();
  }, [user]);

  const handleViewDateMeals = async (dateStr: string) => {
    setSelectedDate(dateStr);
    try {
      const { data, error } = await supabase
        .from('meals')
        .select('*')
        .eq('user_id', user?.userId)
        .gte('eaten_at', `${dateStr}T00:00:00.000Z`)
        .lte('eaten_at', `${dateStr}T23:59:59.999Z`);

      if (error) throw new Error(error.message);
      setSelectedMeals(data || []);
    } catch (e) {
      console.error('Failed to load meals for date:', e);
    }
  };

  return (
    <div className="view-wrapper">
      <div className="title-row">
        <div>
          <h2 className="title-large">{t('history')}</h2>
          <span className="subtitle-body">ประวัติบันทึกโภชนาการย้อนหลัง 30 วัน</span>
        </div>
      </div>

      {isLoading ? (
        <div>กำลังโหลด...</div>
      ) : historyItems.length === 0 ? (
        <div
          style={{
            padding: '40px 24px',
            borderRadius: '24px',
            border: '1.5px dashed var(--color-border)',
            color: 'var(--color-muted)',
            fontSize: '14px',
            textAlign: 'center',
          }}
        >
          <Calendar size={48} style={{ margin: '0 auto 16px auto', color: 'var(--color-border)' }} />
          <span>ยังไม่มีประวัติการบันทึกข้อมูลย้อนหลัง</span>
        </div>
      ) : (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
          {historyItems.map((item) => (
            <div
              key={item.id}
              style={{
                padding: '16px',
                borderRadius: '16px',
                border: '1.5px solid var(--color-border)',
                backgroundColor: '#ffffff',
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                textAlign: 'left',
              }}
            >
              <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                <span style={{ fontWeight: 'bold', fontSize: '15px', color: 'var(--color-primary-dark)' }}>
                  {item.log_date}
                </span>
                <div style={{ display: 'flex', gap: '12px', fontSize: '12px', color: 'var(--color-muted)' }}>
                  <span>โปรตีน: {item.total_protein_g.toFixed(1)}g</span>
                  <span>น้ำดื่ม: {item.total_water_ml}ml</span>
                  <span>ปัสสาวะ: {item.total_urine_ml || 0}ml</span>
                </div>
              </div>

              <button
                onClick={() => handleViewDateMeals(item.log_date)}
                style={{
                  background: 'none',
                  border: 'none',
                  color: 'var(--color-primary)',
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '4px',
                  fontWeight: 'bold',
                  fontSize: '14px',
                }}
              >
                <Eye size={18} />
                ดูรายละเอียด
              </button>
            </div>
          ))}
        </div>
      )}

      {/* Date Detail Modal */}
      {selectedDate && (
        <div className="overlay-backdrop" onClick={() => setSelectedDate(null)}>
          <div className="bottom-sheet" onClick={(e) => e.stopPropagation()} style={{ minHeight: '40vh' }}>
            <div className="bottom-sheet-handle"></div>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
              <h3 style={{ fontSize: '18px', fontWeight: 'bold', color: 'var(--color-primary-dark)' }}>
                รายละเอียดของวันที่ {selectedDate}
              </h3>
              <button onClick={() => setSelectedDate(null)} style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--color-muted)' }}>
                <X size={24} />
              </button>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', textAlign: 'left' }}>
              {selectedMeals.length === 0 ? (
                <div style={{ color: 'var(--color-muted)', fontSize: '14px', padding: '16px 0' }}>
                  ไม่มีประวัติเมนูอาหารในวันนี้
                </div>
              ) : (
                selectedMeals.map((m) => (
                  <div
                    key={m.id}
                    style={{
                      padding: '12px',
                      borderRadius: '12px',
                      border: '1.5px solid var(--color-border)',
                      fontSize: '14px',
                    }}
                  >
                    <div style={{ fontWeight: 'bold' }}>{m.foodName}</div>
                    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', color: 'var(--color-muted)', marginTop: '4px' }}>
                      <span>ปริมาณ {m.quantityG}g ({t(m.mealType as any)})</span>
                      <span style={{ color: 'var(--color-primary)', fontWeight: 'bold' }}>โปรตีน {m.proteinG.toFixed(1)}g</span>
                    </div>
                  </div>
                ))
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
